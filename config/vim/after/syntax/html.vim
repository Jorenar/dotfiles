" Folding
syntax region htmlFold fold transparent keepend extend containedin=htmlHead,htmlH\d
      \ start = "<\z(\<\(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|para\|source\|track\|wbr\>\)\@![a-z-]\+\>\)\%(\_s*\_[^/]\?>\|\_s\_[^>]*\_[^>/]>\)"
      \ end   = "</\z1\_s*>"
