Write-Host "`nDetective by NameLessF0" -ForegroundColor Black
Write-Host "`nGitHub: https://github.com/NameLessF0" -ForegroundColor White
Write-Host "`nDiscord: https://discord.gg/k7hcQKRXQt" -ForegroundColor Blue
Write-Host "`nRunning the script..." -ForegroundColor Red

$extensions = @("*.jar", "*.bat", "*.exe", "*.dll")
$drives = Get-PSDrive -PSProvider FileSystem

$results = foreach ($drive in $drives) {
   Write-Host "Scanning $($drive.Root)..." -ForegroundColor Gray
   Get-ChildItem -Path "$($drive.Root)\*" -Include $extensions -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
       [PSCustomObject]@{
           Name        = $_.Name
           Location    = $_.FullName
           LastAccess  = $_.LastAccessTime
       }
   }
}

if ($results) {
   # Displaying as a list/table in the console
  $results | Format-Table -AutoSize

   # Still saving to CSV in case the list is too long to scroll through
   $results | Export-Csv -Path "SystemFileScan.csv" -NoTypeInformation
   Write-Host "`nScan complete! Results also saved to SystemFileScan.csv" -ForegroundColor Green
} else {
   Write-Host "`nNo matching files found." -ForegroundColor Yellow
 }