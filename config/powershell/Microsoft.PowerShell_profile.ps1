# PowerShell $profile file

Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit
Set-PSReadlineKeyHandler -Key ctrl+u -Function BackwardDeleteLine
