	.section .rodata
	@ general global constants
	@ welcome_message: a string that welcomes user to pizza shop
	@ input: a string that formats user input, assists in getting input
	@ order_report: a string that reports number of pizzas ordered by user
	@ goodbye_message: a string that thanks user for patronage
welcome_message:
	.ascii	"Welcome to the HD Pizza Shop, where every pizza is assembled to perfection!\n\0"
	.align	2
input:
	.ascii	"%c\0"
	.align	2
order_report:
	.ascii	"You have ordered %d pizzas.\n\0"
	.align	2
goodbye_message:	
	.ascii	"Thank you! Please stop by for a byte again sometime!\n\0"
	.align	2
	
	@ price and cost global constants
	@ small_price: an integer with value 10 representing small pizza price
	@ medium_price: an integer with value 15 representing medium pizza price
	@ large_price: an integer with value 20 representing large pizza price
	@ cost_report: a string that reports total cost of ordered pizzas
small_price:	.word	10
medium_price:	.word	15
large_price:	.word	20
cost_report:	
	.ascii	"Your total is $%d.\n\0"
	.align	2
	
	@ pizza order prompts global constants
	@ size_prompt: a string that asks user what size of pizza they would like to order
	@ another_prompt: a string that asks user if they would like to order another pizza
size_prompt:
	.ascii	"What size of pizza would you like to order? (s/m/l) \0"
	.align	2
another_prompt:
	.ascii	"Would you like to order another pizza? (y/n) \0"
	.align	2

	.text
	.global	cost
@ cost function, takes three parameters (x, y, z) and returns:
@ x*small_price + y*medium_price + z*large_price
cost:
	@ set up stack frame for cost
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, fp, #16	@ allocate space for four local variables
	@ local variables:
	@ x: an integer at fp-8 representing number of small pizzas
	@ y: an integer at fp-12 representing number of medium pizzas
	@ z: an integer at fp-16 representing number of large pizzas
	@ total: an integer at fp-20 representing cost for all ordered pizzas

	@ store first argument to local variable x (fp-8)
	str	r0, [fp, #-8]

	@ store second argument to local variable y (fp-12)
	str	r1, [fp, #-12]

	@ store second argument to local variable z (fp-16)
	str	r2, [fp, #-16]

	@ calculate cost for x (number of small pizzas)
	ldr	r0, =small_price
	ldr	r1, [r0]	@ get price value for small pizza
	ldr	r2, [fp, #-8]	@ get number of small pizzas
	mul	r2, r2, r1	@ multiply x by small pizza price and put in r2

	@ store cost to total
	str	r2, [fp, #-20]

	@ calculate cost for y (number of medium pizzas)
	ldr	r0, =medium_price
	ldr	r1, [r0]	@ get price value for medium pizza
	ldr	r2, [fp, #-12]	@ get number of medium pizzas
	mul	r2, r2, r1	@ multiply y by medium pizza price and put in r2

	@ add medium pizzas cost to total
	ldr	r0, [fp, #-20]	@ get current total cost for x small pizzas
	add	r1, r2, r0	@ add cost for y medium pizzas to current total

	@ store current cost of y medium pizzas and x small pizzas to total
	str	r1, [fp, #-20]

	@ calculate cost for z (number of large pizzas)
	ldr	r0, =large_price
	ldr	r1, [r0]	@ get price value for large pizza
	ldr	r2, [fp, #-16]	@ get number of large pizzas
	mul	r2, r2, r1	@ multiply z by large pizza price and put in r2

	@ add large pizzas cost to total
	ldr	r0, [fp, #-20]	@ get current total cost for small and medium pizzas
	add	r1, r2, r0	@ add cost for z large pizzas to current total

	@ store overall cost of pizzas to total
	str	r1, [fp, #-20]
	
	@ return the sum result
	ldr	r1, [fp, #-20] @ get total cost and put in r1
	mov	r0, r1
	
	@ tear down stack frame
	sub	sp, fp, #4
	pop	{fp, pc}
	.align	2
	
	.text
	.global sum
@ sum function, takes three parameters (x, y, z) and returns their sum (x+y+z)
sum:
	@ set up stack frame for sum
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, fp, #12	@ allocate space for three local variables
	@ local variables:
	@ x: an integer at fp-8, y: an integer at fp-12, z: an integer at fp-16

	@ store first argument to local variable x (fp-8)
	str	r0, [fp, #-8]

	@ store second argument to local variable y (fp-12)
	str	r1, [fp, #-12]

	@ store second argument to local variable z (fp-16)
	str	r2, [fp, #-16]

	@ load values of arguments into r0, r1, and r2
	ldr	r0, [fp, #-8]	@ load value of x into r0
	ldr	r1, [fp, #-12]	@ load value of y into r1
	ldr	r2, [fp, #-16]	@ load value of z into r2

	@ add x and y and put in r1
	add	r1, r0, r1

	@ add sum of x and y to z and put in r2
	add	r2, r2, r1
	
	@ return the sum result
	mov	r0, r2
	
	@ tear down stack frame
	sub	sp, fp, #4
	pop	{fp, pc}
	.align	2

	.text
	.global main
@ main function
main:	
	@ set up stack frame for main
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24	@ allocate space for six local variables
	@ local variables:
	@ num_small: an integer at fp-8, stores user input for number of small pizzas
	@ num_medium: an integer at fp-12, stores user input for number of medium pizzas
	@ num_large: an integer at fp-16, stores user input for number of large pizzas
	@ num_pizzas: an integer at fp-20, stores user input for total number of pizzas
	@ total_cost: an integer at fp-24, stores total cost of the pizzas ordered
	@ input: a string at fp-28, stores user input for pizza order (y, n, s, m, l)
	
	@ print welcome message to user
	ldr	r0, welcome_message_ptr
	bl	printf

	@ initialize num_small (fp-8) to 0
	mov	r0, #0
	str	r0, [fp, #-8]	@ store 0 to num_small

	@ initialize num_medium (fp-12) to 0
	mov	r0, #0
	str	r0, [fp, #-12]	@ store 0 to num_medium

	@ initialize num_large (fp-16) to 0
	mov	r0, #0
	str	r0, [fp, #-16]	@ store 0 to num_large

loop_body:
	@ print prompt asking user what size of pizza to order
	ldr	r0, size_prompt_ptr
	bl	printf

	@ store user input to input (fp-28)
	ldr	r0, input_ptr
	sub	r1, fp, #28
	bl	scanf
	bl	getchar	@ discard the newline character in the buffer
	
	@ load input (fp-28) value into r0 for comparisons
	ldr	r0, [fp, #-28]
	
	@ check if user entered 'l' for a large pizza
	cmp	r0, #'l'
	beq	else	@ skip to else branch

	@ check if user entered 'm' for a medium pizza
	cmp	r0, #'m'
	beq	elseif	@ skip to elseif branch

	@ if not 'l' or 'm', user entered 's'
	@ load num_small (fp-8) value into r0
	ldr	r0, [fp, #-8]

	@ add one to num_small and put in r1
	add	r1, r0, #1

	@ store new small pizza amount to num_small (fp-8)
	str	r1, [fp, #-8]
	
loop_condition:
	@ print prompt asking if user would like to order another pizza
	ldr	r0, another_prompt_ptr
	bl	printf

	@ store user input to input (fp-28)
	ldr	r0, input_ptr
	sub	r1, fp, #28	@ get address of user input
	bl	scanf
	bl	getchar	@ discard the newline character in the buffer
	
	@ get value of input (fp-28) for comparison
	ldr	r0, [fp, #-28]

	@ compare user input to 'y'
	cmp	r0, #'y'
	beq	loop_body	@ go to loop body if input is 'y'

	@ if user input is not 'y', skip to endif branch
	b	endif

else:	@ user entered 'l'
	@ load num_large (fp-16) value into r0
	ldr	r0, [fp, #-16]

	@ add one to num_large and put in r1
	add	r1, r0, #1

	@ store new number of large pizzas value into num_large (fp-16)
	str	r1, [fp, #-16]

	@ go back to loop condition
	b	loop_condition

elseif:	@ user entered 'm'
	@ load num_medium (fp-12) value into r0
	ldr	r0, [fp, #-12]

	@ add one to num_medium and put in r1
	add	r1, r0, #1

	@ store new number of medium pizzas value into num_medium (fp-12)
	str	r1, [fp, #-12]

	@ go back to loop condition branch
	b	loop_condition
	
endif:
	@ load number of each pizza size into registers r0, r1, r2 for call to sum function
	ldr	r0, [fp, #-8]	@ get value of num_small
	ldr	r1, [fp, #-12]	@ get value of num_medium
	ldr	r2, [fp, #-16]	@ get value of num_large

	@ call sum on num_small, num_medium, and num_large to find total number of pizzas
	bl	sum

	@ store sum result, total number of pizzas, to num_pizzas (fp-20)
	str	r2, [fp, #-20]

	@ load num_small, num_medium, and num_large values into r0, r1, r2
	ldr	r0, [fp, #-8]	@ get number of small pizzas and put in r0
	ldr	r1, [fp, #-12]	@ get number of medium pizzas and put in r1
	ldr	r2, [fp, #-16]	@ get number of large pizzas and put in r2

	@ call cost function on num_small, num_medium, and num_large
	bl	cost

	@ store cost to local variable total_cost (fp-24)
	str	r0, [fp, #-24]

	@ print a report for number of pizzas user ordered
	ldr	r0, order_report_ptr
	ldr	r1, [fp, #-20]	@ get value of num_pizzas and load to r1
	bl	printf

	@ print a report for total cost of pizzas user ordered
	ldr	r0, cost_report_ptr
	ldr	r1, [fp, #-24]	@ get value of total_cost and load to r1
	bl	printf

	@ print goodbye message to user
	ldr	r0, goodbye_message_ptr
	bl	printf

	@ return 0
	mov	r0, #0
	
	@ tear down stack frame
	sub	sp, fp, #4
	pop	{fp, pc}
	.align	2

@ pointers to strings
welcome_message_ptr:	.word	welcome_message
input_ptr:	.word	input
order_report_ptr:	.word	order_report
cost_report_ptr:	.word	cost_report
goodbye_message_ptr:	.word	goodbye_message
size_prompt_ptr:	.word	size_prompt
another_prompt_ptr:	.word	another_prompt
