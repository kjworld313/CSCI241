# Hardware Design Course Portfolio

***

## Project Information (pizza_system.s)
### Details:
The software simulates a restaurant pizza ordering system. Users can order pizzas of varying sizes and receive an informative order receipt. 

### Language: 
Assembly Language (ARM architecture)

### Technical details: 
Program prompts user for pizza size input and updates corresponding quantities in registers using branching instructions. Once the user's order is complete, the program invokes a custom `sum` procedure to calculate total order cost, then stores and retrieves the pizza quantities and cost to print a detailed receipt. Control flow is managed via procedure calls, loops, and branches.  

## Important Notes
I wrote the program 'pizza_system.s' on a Raspberry Pi. Please use an ARM machine to run ASM code. 

## Program Instructions
In order to run the program, use 'gcc pizza_system.s -o pizza_system' to compile and './pizza_system' to run the executable in the terminal. 

## Author
Author: Katelynn Olson

Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.