if get(g:, 'php_folding', 0)
  call utils#syntax#rule_append('phpRegion', 'fold')
endif
