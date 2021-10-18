SetFormatProg "uncrustify --l CPP base kr mb stroustrup"

let b:sBnR = #{ make: [ 0, "g++ -std=gnu++14 -Wall -g % -o %:t:r -lm" ] }
