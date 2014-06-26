CC 		= cxstm8

TARGET 	= main

SRC 	= $(TARGET).c

OBJDIR 	= $(CURDIR)

EXT = h12
OUTFILE = demo12

# Define all object files.
OBJ = $(SRC:%.c=$(OBJDIR)/%.o)

HEX  = chex  -o $(OUTFILE).s19 

#$(OUTFILE).$(EXT)

MSG_BEGIN 	  = ---- begin ----
MSG_END 	  = ----  end  ----
MSG_LINKING	  = Linking:
MSG_COMPILING = Compiling C:


all: begin build end


begin:
	@echo .
	@echo $(CURDIR)
	@echo $(MSG_BEGIN)
	

build: 
	$(OBJ)
	$(OUTFILE).s19

end:
	@echo .
	@echo $(MSG_END)
	
main.o : main.c
	$(CC) main.c
	
$(OUTFILE).s19: 
	@echo Creating Hex Records
	@$(HEX)
	
#$(OUTFILE).$(EXT)
#$(OUTFILE).$(EXT) : $(OUTFILE).mak $(OBJS) 	
#	@echo Linking...
#	@$(LINK) $(LINKFILE)
#	@$(ECHO) Creating Absolute Listings
#	@$(CLABS)
		
	
# Compile: create object files from C source files.
$(OBJDIR)/%.o : %.c
	@echo .
	@echo $(MSG_COMPILING) $<
	$(CC) +mods $<