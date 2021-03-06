AS = ca65
CC = cc65
LD = ld65
IPS = flips.exe

.PHONY: clean

%.o: %.asm
	$(AS) -g -l "$@.lst" --create-dep "$@.dep" --debug-info $< -o $@

%.o.bin: %.asm
	$(AS) -g -l "$@.lst" --create-dep "$@.dep" --debug-info $< -o $@.o
	$(LD) $@.o -C layoutbin -o $@

smb2j-slowmode.zip: patch.ips README.txt
	zip $@ patch.ips README.txt

patch.ips: main.fds
	$(IPS) --create --ips "original.fds" "main.fds" $@

main.fds: layout sm2data2.o.bin sm2data3.o.bin sm2data4.o.bin fdswrap.o
	$(LD) --dbgfile $@.dbg -C layout fdswrap.o -o $@

clean:
	rm -f *.dep smb2j-slowmode.zip main*.fds patch.ips *.o *.o.bin

include $(wildcard *.dep)
