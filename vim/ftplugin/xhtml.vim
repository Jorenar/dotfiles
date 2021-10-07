SetFormatProg "tidy -asxhtml -q -m -w -i --show-warnings 0 --show-errors 0 --tidy-mark no --doctype loose"

let b:sBnR = #{
      \   make: [ 0, "tidy -asxhtml -quiet -errors --gnu-emacs yes %" ],
      \   run:  [ 1, "$BROWSER %:p" ],
      \ }
