# AVR-makefile

*One Makefile to rule them all, One Makefile to find them,
One Makefile to bring them all, and in the darkness bind them*

A generic makefile, tuned for:
- Microchip/Atmel AVR microcontrollers (*default*)
- STM32 ARM microcontrollers (e.g. F103, L031, ...)

## What I can change

### Project organization

1. Give a name to the project changing `PROJ_NAME`. This will be the name of the binary output too.
1. Add sources (C, C++, assembly) to `SRCS`.

### AVR Architecture

1. Choose the target chip and put in `MCU`.
1. Choose the clock frequency and put in `F_CPU`.

### ARM Architecture

1. Comment out all AVR lines inside ARCHITECTURE section.
1. Choose the target chip and put in `MCU`.
1. You may want to download or write your own startup file, then add it to `SRCS`.
1. Download/write an appropriate linker script and add to `LDSCRIPT`.