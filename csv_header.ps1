function read_csv_header([string]$filename) {
    # add ref to function script
    . C:\scripts\ps\arrays_to_hash.ps1


    # pull header and first row of data from csv:
    $keys = ((gc $filename)[0] -split(','))
    "keys $keys"
    $vals = ((gc $filename)[1] -split(','))
    "vals $vals"

    # zip 2 arrays:
    $hash = arrays_to_hash -keys $keys -vals $vals
    $hash
}