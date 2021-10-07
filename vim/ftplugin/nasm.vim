let b:sBnR = #{ make: [ 0, "nasm -f elf64 -g % && ld -g -o %:t:r %:t:r.o && rm %:t:r.o" ] }
