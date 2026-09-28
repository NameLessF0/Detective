Write-Host "`nDetective by NameLessF0" -ForegroundColor Black
Write-Host "`nGitHub: https://github.com/NameLessF0" -ForegroundColor White
Write-Host "`nDiscord: https://discord.gg/k7hcQKRXQt" -ForegroundColor Blue
Write-Host "`nAwaking the Detective..." -ForegroundColor Red

# Target strings to look for
$targetStrings = @(
    "CrystalAura", "AutoCrystal", "OneHitCrystal", "AutoStun", "StunSlam", 
    "AutoTotem", "InventoryTotem", "InvMove", "TriggerBot", "MaceDMG", 
    "ShieldBreaker", "AutoPot", "HitBox", "Stun-Slam", "CrystalOptimizer", "AnchorMacro"
)

# File extensions to scan
$extensions = @("*.exe", "*.dll", "*.bat", "*.jar")

# Get all file system drives
$drives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root

# Parallel scanning for maximum speed
$results = $drives | ForEach-Object -Parallel {
    $root = $_
    $exts = $using:extensions
    $strings = $using:targetStrings
    }
    
    Write-Host "Scanning $root..." -ForegroundColor Gray
    
    # Scan files including Hidden and System attributes
    Get-ChildItem -Path "$root\*" -Include $exts -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
        $filePath = $_.FullName
        
        # Search for the target strings inside the file content
        $match = Select-String -Path $filePath -Pattern $strings -ErrorAction SilentlyContinue | Select-Object -First 1
        
        if ($match) {
            [PSCustomObject]@{
                Name   = $_.Name
                Location = $filePath
                Cheat  = $match.Pattern
            }
        }
    }
} -ThrottleLimit 8

# Output results
if ($results) {
    Write-Host "`n[!] CHEATS FOUND:" -ForegroundColor Cyan
    $results | Format-Table -AutoSize

    # Save results to CSV
    $results | Export-Csv -Path "Detective_Scan_Results.csv" -NoTypeInformation
    Write-Host "`n[+] The review was conducted. Results also saved to Detective_Scan_Results.csv" -ForegroundColor Green
} else {
    Write-Host "`n[-] No cheats were found." -ForegroundColor Yellow
}
