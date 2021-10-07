let b:sBnR = #{ make: [ 0, "as -o %:t:r.o % && ld -s -o %:t:r %:t:r.o && rm %:t:r.o" ] }
