# PowerShell $profile file
#   default location: ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit
Set-PSReadlineKeyHandler -Key ctrl+u -Function BackwardDeleteLine
