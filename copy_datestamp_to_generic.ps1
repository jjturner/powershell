param(
    [string]$source_path,
    [string]$source_name,
    [string]$dest_path   = $source_path,
       [int]$day_offset  = 0,
    [string]$date_format = "yyyyMMdd"
)

# Arbitrary omission or inclusion of "\" at the end of the path ref must be handled -
# Even in the case of coercion from string to FileSystem object (e.g. via $foo = dir $path),
# Powershell will implicitly append the "\" to root (i.e., C:\) but only in that special case -
# all other cases the trailing backslash is at the caller's discretion.
# Given this situation, we need to conditionally append the backslash:
$source   = if ($source_path[-1] -ne '\'){ "$($source_path)\" } else { $source_path }
$target   = if ($dest_path[-1] -ne '\'){ "$($dest_path)\" } else { $dest_path }
$file     = $filehash.BaseName
$ext      = $filehash.Extension
$name     = $filehash.Name

$date_str = $(get-date).AddDays($day_offset).ToString($date_format)

copy "$source$date_str$source_name" "$target$source_name"