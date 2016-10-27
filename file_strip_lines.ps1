param(
    [string]$path,
    [bool]$remove_blank_lines = $true,
    [string]$badchars = "`f"
)

<# 
   Pipeline exceptions have been causing SSIS packages to fail -- the root cause has been traced back to
   flat files terminating in the formfeed character (U000C), which the pipeline is unable to reconcile with
   the static typing of the mapped data columns.

   Technically, the EOF sequence in these cases has been `f`r`n (form feed, carriage return, line feed), 
   which the pipeline buffer seems to attempt to map to 3 separate columns:
    - col1 is string, and the buffer can accept non-printable unicode characters
    - col2 is datetime -- here the buffer must successfully parse the passed in character as a date
    - col3 is datetime -- again the same situation

   The errors returned from the failed execution indicate that data is not compatible with col2, hence
   the deductions made above.

   The below attempts to prevent these offending characters from interfering with the data flow by entirely
   filtering out their respective lines within the file prior to sending the flat file through the pipeline.

   As a best-practice, the original extract is left intact, while the filtered data is generated as a temp file,
   then subsequently deleted upon successful execution of the package.
#>

$filehash = dir $path | select DirectoryName, Basename, Extension

# DirectoryName will lack the '\' suffix unless path is on root,
# so we need to conditionally append it:
$dir      = if ($filehash.DirectoryName[-1] -ne '\'){ "$($filehash.DirectoryName)\" } else { $filehash.DirectoryName }
$file     = $filehash.BaseName
$ext      = $filehash.Extension

if ($remove_blank_lines)
{
    Get-Content $path | where { $_.Trim(" `t`f") } | Set-Content "$dir${file}_tmp${ext}"
}
else {
    Get-Content $path | where {$_ -notmatch $badchar} | Set-Content "$dir${file}_tmp${ext}"
}