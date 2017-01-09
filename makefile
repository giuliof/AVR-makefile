# Name of the project
PROJ_NAME  = TestSerial

######################################################################
#                             SOURCES                                #
######################################################################

## Directories ##
# This is where the source files are located,
# which are not in the current directory
SRC_DIR       = ./src

# The header files we use are located here
INC_DIR  =  ./include
INC_DIR  += .

BUILD_DIR     = build
OUTPUT_DIR    = output

## FILES ##
# c files
#~ SRCS       = main.c
SRCS      = TestSerial.cpp

# asm files
# S maiuscola! Invoca prima il compilatore gcc che interpreta macro e altro
ASRC       = BasicSerial.S

# header files
# Specify here libraries! Makefile will check existance before launching
DEPS       = BasicSerial.h

# Object files
# Automatically declares object file names
OBJS          = $(patsubst %.c,   $(BUILD_DIR)/%.o,   $(filter %.c,$(SRCS)) )
OBJS         += $(patsubst %.cpp, $(BUILD_DIR)/%.o,   $(filter %.cpp,$(SRCS)) )
OBJS         += $(patsubst %.s,   $(BUILD_DIR)/%.s.o, $(filter %.s,$(ASRC)) )
OBJS         += $(patsubst %.S,   $(BUILD_DIR)/%.s.o, $(filter %.S,$(ASRC)) )

# Virtual Paths
# Tell make to look in that folder if it cannot find a source
# in the current directory
vpath %.c   $(SRC_DIR)
vpath %.cpp $(SRC_DIR)
vpath %.S   $(SRC_DIR)
vpath %.h   $(INC_DIR)

######################################################################
#                         SETUP TOOLS                                #
######################################################################

# GCC/programming Tools
CC         = avr-gcc
CXX        = avr-g++
OBJCOPY    = avr-objcopy
OBJDUMP    = avr-objdump
GDB        = avr-gdb
AS         = avr-as
SIZE       = avr-size

# Microcontroller
MCU        = attiny44
F_CPU      = 8000000

### GCC options ###

## Compiler flags ##
# Do not run the linker
CFLAGS     = -c
# Debug informations
CFLAGS    += -g
# Auto optimisation
CFLAGS    += -Os
# All warning messages
CFLAGS    += -Wall
# Puts functions and data into its own section - remove thread-safe things
CFLAGS    += -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics
# Microcontroller
CFLAGS    += -mmcu=$(MCU)
# Clock speed
CFLAGS    += -DF_CPU=$(F_CPU)L
# Header files
CFLAGS    += $(addprefix -I,$(INC_DIR))

## CXX flags are the same as CC ones here!
CXXFLAGS = $(CFLAGS)

# Linker flags
LFLAGS     = -mmcu=$(MCU)
LFLAGS    += $(addprefix -I,$(INC_DIR))

.PHONY: clean

all:     $(OUTPUT_DIR)/$(PROJ_NAME).hex

# invokes CC compiler before assemblying
$(BUILD_DIR)/%.s.o : %.S $(DEPS)
	@echo -e "\033[1;33m[Assembling  ]\033[0m $^"
	@mkdir -p ${BUILD_DIR}
	$(CC) $(CFLAGS) $< -o $@

# pure asm	
$(BUILD_DIR)/%.s.o : %.s $(DEPS)
	@echo -e "\033[1;33m[Assembling  ]\033[0m $^"
	@mkdir -p ${BUILD_DIR}
	$(CC) $(CFLAGS) $< -o $@

# .cxx files
$(BUILD_DIR)/%.o:  %.cpp $(DEPS)
	@echo -e "\033[1;33m[Compiling   ]\033[0m $^"
	@mkdir -p ${BUILD_DIR}
	$(CXX) $(CXXFLAGS) $< -o $@

# .c files
$(BUILD_DIR)/%.o:  %.c $(DEPS)
	@echo -e "\033[1;33m[Compiling   ]\033[0m $^"
	@mkdir -p ${BUILD_DIR}
	$(CC) $(CFLAGS) $< -o $@

$(OUTPUT_DIR)/$(PROJ_NAME).elf: $(OBJS)
	@echo -e "\033[1;33m[Linking     ]\033[0m $@"
	@mkdir -p ${OUTPUT_DIR}
	$(CC) $(LFLAGS) -o $@ $(foreach file, $^, $(file)) -lm
	$(OBJDUMP) -h -S $@ > $(OUTPUT_DIR)/$(PROJ_NAME).lss

$(OUTPUT_DIR)/$(PROJ_NAME).hex: $(OUTPUT_DIR)/$(PROJ_NAME).elf
	$(OBJCOPY) -O ihex -R .eeprom $^ $@

size: $(OUTPUT_DIR)/$(PROJ_NAME).elf
	$(SIZE) -C --mcu=$(MCU) $(OUTPUT_DIR)/$(PROJ_NAME).elf

clean:
	@echo -e "\033[1;33m[Cleaning   ]\033[0m"
	@rm -f $(BUILD_DIR)/*
	@rm -f $(OUTPUT_DIR)/*
