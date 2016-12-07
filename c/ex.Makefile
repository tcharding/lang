OUT = lib/alib.a
CC = g++
ODIR = obj
SDIR = src
INC = -Iinc

_OBJS = a_chsrc.o a_csv.o a_enc.o a_env.o a_except.o \
    	a_date.o a_range.o a_opsys.o
OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))


$(ODIR)/%.o: $(SDIR)/%.cpp 
    $(CC) -c $(INC) -o $@ $< $(CFLAGS) 

$(OUT): $(OBJS) 
    ar rvs $(OUT) $^

.PHONY: clean

clean:
    rm -f $(ODIR)/*.o $(OUT)
