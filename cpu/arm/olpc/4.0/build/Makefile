BASEDIR     = $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../../../../)
OS          = $(shell uname)
HOSTCPU     = $(shell ${BASEDIR}/forth/lib/hostcpu.sh)
HOSTDIR     = ${BASEDIR}/cpu/${HOSTCPU}/${OS}

TAGFILES    = ${BASEDIR}/cpu/arm/build/*.tag *.tag
CLIENTDIR   = ${BASEDIR}/clients
CLIENTPROGS = ${CLIENTDIR}/emacs/arm/emacs

ROMNAME     = olpc
BUILDFLAGS  = 

all: ${ROMNAME}.rom tags

${ROMNAME}.tag: ${ROMNAME}.rom

tags: ${ROMNAME}.tag
	${BASEDIR}/forth/lib/toctags ${BASEDIR} ${TAGFILES}

${ROMNAME}.rom: FORCE build ${CLIENTPROGS} ${HOSTDIR}/forth ${HOSTDIR}/armforth
	./build ${BUILDFLAGS} $@

${HOSTDIR}/forth:
	make -C ${HOSTDIR} forth

${HOSTDIR}/armforth:
	make -C ${HOSTDIR} armforth

${CLIENTDIR}/emacs/arm/emacs:
	make -C ${CLIENTDIR}/emacs/arm emacs

build:
	ln -sf ${BASEDIR}/forth/lib/build.sh build

clean:
	rm -f *.dic *.log headers *~ *.elf *.di *.img builton.fth build *.rom *.version tags *.tag

clean-all: clean
	@make -C ../../../build clean
	@make -C ${HOSTDIR} clean

.PHONY: FORCE clean all clean-all

# LICENSE_BEGIN
# Copyright (c) 2009 FirmWorks
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# LICENSE_END
