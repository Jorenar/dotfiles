SetFormatProg "autopep8 -"
compiler! pyunit

let b:sBnR = #{ make: [ 1, "python %" ] }
