# Path to Linux utilities
ZXCC    = zxcc
VOL180  = ../Tools/linux/vol180/vol180
MKTASK  = ../Tools/linux/mktask/mktask

# Path to CP/M utilities
ZSM4    = ../Tools/cpm/zsm4.com
DRLINK  = ../Tools/cpm/drlink.com

.PREFIX:
.PREFIX: .mac .rel

SRCS = main.mac \
	termdef.mac \
	fileio.mac \
	scrn.mac \
	cmds.mac \
	cpmio.mac \
	rsxio.mac

OBJS = $(SRCS:.mac=.rel)

all: ted.com ted.tsk

$(OBJS): %.rel: %.mac *.inc
	$(ZXCC) $(ZSM4) -"=$<"

ted.com: $(OBJS)
	$(ZXCC) $(DRLINK) -"ted=termdef,main,fileio,scrn,cmds,cpmio"
	mv ted.sym tedcpm.sym

ted.bin: $(OBJS)
	$(ZXCC) $(DRLINK) -"ted.bin=termdef,main,fileio,scrn,cmds,rsxio,syslib.lib[s]"
	mv ted.sym tedrsx.sym

ted.tsk: ted.bin
	$(MKTASK) $< -o $@ -name "...TED" -id "`date +%y%m%d`" -pri 65

copy:
	cpmrm -f p112 /dev/fd0 0:ted.com
	cpmcp -f p112 /dev/fd0 ted.com 0:

clean:
	rm -f ted.com ted.bin ted.tsk *.rel *.sym *.prn *.crf core *~ *.\$$\$$\$$
