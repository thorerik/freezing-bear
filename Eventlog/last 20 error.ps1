Get-EventLog -LogName system -entrytype error -newest 20 | Format-Table -wrap
