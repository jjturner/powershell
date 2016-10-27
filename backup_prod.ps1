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

foreach ($db in $db_names) {

    $bak_set += "${db}_${dt}.bak"
    Backup-SqlDatabase -Database $db -BackupFile "${bak_path}\$($bak_set[$i])" -Checksum -CopyOnly
    $i ++
}

cd c:\
foreach ($backup in $bak_set)
{
    Copy-Item -Path "\\${backup_os_server}\backups\$backup" -Destination "\\${restore_os_server}\backups\"
}

# $files = dir "\\tpcsqldev1\backups\*" | select name

Set-Location "${sqlps_root}sql\${restore_os_server}\${restore_db_server}\databases"
$i = 0

foreach ($backup in $bak_set) {
# foreach ($file in $files) {
    Restore-SqlDatabase -Database $db_names[$i] -BackupFile "${bak_path}\$backup" -Checksum -ReplaceDatabase
    $i ++
}