# Define programs and commands.

#TOOLCHAIN = elf
# Define programs and commands.
#SHELL 	= sh
CC 		= cxstm8
#OBJCOPY = arm-$(TOOLCHAIN)-objcopy
#OBJDUMP = arm-$(TOOLCHAIN)-objdump
#SIZE 	= arm-$(TOOLCHAIN)-size
#NM 		= arm-$(TOOLCHAIN)-nm
#REMOVE 	= rm -f
#COPY 	= cp	


.PHONY : .VARIABLES
	@echo .VARIABLES = $(.VARIABLES)
	
# Define Messages

MSG_ERRORS_NONE 		= Errors: none
MSG_BEGIN 				= -------- begin --------
MSG_END 				= --------  end  --------
MSG_SIZE_BEFORE 		= Size before: 
MSG_SIZE_AFTER 			= Size after:
MSG_FLASH 				= Preparing load file for Flash:
MSG_EXTENDED_LISTING 	= Creating Extended Listing:
MSG_SYMBOL_TABLE 		= Creating Symbol Table:
MSG_LINKING 			= Linking:
MSG_COMPILING	 		= "Compiling C:"
MSG_ASSEMBLING_ARM 		= "Assembling (ARM-only):"
MSG_CLEANING 			= Cleaning project:

