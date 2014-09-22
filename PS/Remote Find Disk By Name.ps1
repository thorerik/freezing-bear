Invoke-Command -ComputerName <csv list of hosts> {get-PSDrive | select Description,name | where {$_.Description -eq "<disk name>"}}
