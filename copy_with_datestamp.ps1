param(
    [string]$source_file,
    [string]$dest_path,
       [int]$day_offset  = 0,
    [string]$date_format = "yyyyMMdd"
)

$filehash = dir $source_file | select DirectoryName, Basename, Extension, Name

# DirectoryName from a full file reference will lack the '\' suffix unless path is on root...
# (above statement effectively coerces the string to a File object)
# However, in this case, the parameter of interest is the raw Directory tree provided by $dest_path
# which doesn't interpolate to a File object and thus retains the arbitrary discretion of the
# caller in terms of providing the trailing backslash or not.
# In either case we need to conditionally append the backslash:
$target   = if ($dest_path[-1] -ne '\'){ "$($dest_path)\" } else { $dest_path }
$file     = $filehash.BaseName
$ext      = $filehash.Extension
$name     = $filehash.Name

$date_str = $(get-date).AddDays($day_offset).ToString($date_format)

copy $source_file "$target$date_str$name"