x86 Assembly Snake Game
This was one of my first attempts at making a game using low-level programming. Interacting directly with the hardware was not an easy thing to understand at the beginning but things got better eventually.

Why I built this:
The goal was to try something other than c++ and this was a semester end project that i had undertaken. This project forced me to manage memory manually and understand the PC BIOS interrupts that make everything happen behind the scenes.

Technical Highlights
Video Memory Manipulation: I bypassed standard print statements and wrote directly to the 0xB800h video segment to render the snake and the game board.

Interrupt Handling: Used INT 16h to capture real-time keyboard input for movement control (Up, Down, Left, Right).

Game Logic: Implemented a real-time game loop with custom delay subroutines to control the speed and difficulty.

Low-Level Mechanics: Used stack operations (pusha/popa) and segment registers to ensure the game runs efficiently within the 16-bit environment.

How to Run
To run this, you'll need an assembler like NASM and an emulator like DOSBox:

Assemble the file: nasm snake.asm -o snake.com

Run it in DOSBox: snake.com
