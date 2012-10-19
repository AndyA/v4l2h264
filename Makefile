.PHONY: all clean

VPATH = ../common

CFLAGS=-Wall -g3 `pkg-config --cflags libv4l2`
LDFLAGS=-lc -lm -lpthread -lasound `pkg-config --libs libv4l2`

BINS=capture
BINOBJS=$(addsuffix .o,$(BINS))
MISCOBJS=
OBJS=$(BINOBJS) $(MISCOBJS)
DEPS=$(OBJS:.o=.d) 

all: $(BINS)

%: %.o $(MISCOBJS)
	cc -o $@ $^ $(LDFLAGS)

%.d: %.c
	@$(SHELL) -ec '$(CC) -MM $(CFLAGS) $< \
	| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
	[ -s $@ ] || rm -f $@'

include $(DEPS)

tags:
	ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

clean:
	rm -f $(OBJS) $(DEPS) $(BINS) tags

