param(
    [string]$backup_os_server,
    [string]$backup_db_server,
    [string]$restore_os_server,
    [string]$restore_db_server,
    [string[]]$db_names
)

$sqlps_root = 'sqlserver:\'

Set-Location "${sqlps_root}sql\${backup_os_server}\${backup_db_server}\databases"
$dt = get-date -Format yyyyMMddHHmmss

$bak_path = "g:\backups"
$bak_set = @()
$i = 0

"---------------------"
"backing up databases:"
"---------------------"
foreach ($db in $db_names) {
    " -- ${db}..."
    $bak_set += "${db}_${dt}.bak"
    Backup-SqlDatabase -Database $db -BackupFile "${bak_path}\$($bak_set[$i])" -Checksum -CopyOnly
    $i ++
}

"--------------------"
"copying backup sets:"
"--------------------"
cd c:\
foreach ($backup in $bak_set)
{
    " -- ${backup}..."
    Copy-Item -Path "\\${backup_os_server}\backups\$backup" -Destination "\\${restore_os_server}\backups\"
}

# $files = dir "\\tpcsqldev1\backups\*" | select name

<#
================
prep for restore
================
 1) does database exist?
 2) determine default data and log file paths for target server/database:
    a) if database missing
       - list default paths from model db for user to review
       - read-host to let user pick default or designate their own data and log file paths
    b) if not missing use the existing file paths
#>

$target_server = New-Object ('Microsoft.SqlServer.Management.Smo.Server') "$restore_os_server\$restore_db_server"

#$response = Read-Host -Prompt "

Set-Location "${sqlps_root}sql\${restore_os_server}\${restore_db_server}\databases"
$i = 0

foreach ($backup in $bak_set) {
# foreach ($file in $files) {
    Restore-SqlDatabase -Database $db_names[$i] -BackupFile "${bak_path}\$backup" -Checksum -ReplaceDatabase
    $i ++
}