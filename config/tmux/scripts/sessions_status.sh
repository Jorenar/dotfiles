#!/usr/bin/env sh

fmt="$(echo '
#[range=session|#{session_id}]
#{?session_alerts,#[reverse],}
##{?##{==:#S,##S},*,}
#{?session_alerts,####,}
#{?session_marked,M,}
#{session_id}
#{?#{!=:$#S,#{session_id}},:#S,}
#{?session_alerts,#[noreverse],}
#[norange]
' | tr -d '\n')"

exec tmux list-sessions -F "$fmt" | tr '\n' ' '
