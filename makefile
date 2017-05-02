TARGET = 64drive

SRCDIR     ?= src
BUILDDIR   ?= build
INSTALLDIR ?= /usr/local/bin
CC          = g++
CFLAGS     += -Wall -Wextra -std=c++11 -g -O3
LDFLAGS    += -lftdi1
MKDIR       = mkdir -p
DELETE      = rm -rf

# function COMPILE(infile, outfile)
COMPILE=$(CC) $(CFLAGS) -c $1 -o $2

# function LINK(infile, outfile)
LINK=$(CC) $1 $(LDFLAGS) -o $2

# find the source files and build object list
SOURCES := $(notdir $(shell find $(SRCDIR) -type f -name '*.c'))
HEADERS := $(notdir $(shell find $(SRCDIR) -type f -name '*.h'))
OBJS    := $(addprefix $(BUILDDIR)/,$(SOURCES:.c=.o))

.PHONY: all clean install install-link uninstall build

all: $(TARGET)
	@echo Done.

clean:
	$(DELETE) $(BUILDDIR) $(TARGET)

install: $(TARGET)
	cp $(TARGET) $(INSTALLDIR)

install-link: $(TARGET)
	ln -s $(abspath $(TARGET)) $(INSTALLDIR)/$(TARGET)

uninstall:
	rm $(INSTALLDIR)/$(TARGET)

build:
	$(MKDIR) build

$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	$(call COMPILE, $<, $@)

$(TARGET): build $(OBJS)
	$(call LINK, $(OBJS), $(TARGET))

build/%.o: %.cpp
	$(MKDIR) $(dir $@)
	$(COMPILE) -c -o $@ $<
