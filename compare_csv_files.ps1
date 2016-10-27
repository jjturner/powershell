param(
    [string]$old_file,
    [string]$new_file
)

$old_file
$new_file

# add ref to function script
. C:\scripts\ps\csv_header.ps1
'----------------'
'old file header:'
'----------------'
read_csv_header -file $old_file
'----------------'
'new file header:'
'----------------'
read_csv_header -file $new_file

# examine headers and provide sorting columns:
$sort_cols = read-host "sort by columns:"

$old = Import-Csv $old_file | Sort-Object $sort_cols
Out-GridView $old
$new = Import-Csv $new_file | Sort-Object $sort_cols
Out-GridView $new

# run the diff and output breaks
Compare-Object -ReferenceObject $old -DifferenceObject $new | select -ExpandProperty InputObject | Out-GridView