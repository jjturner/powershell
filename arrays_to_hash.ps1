function arrays_to_hash ([array]$keys, [array]$vals) {
<# --------------------------------------------------------------------------
    passing arguments into the parameter signature can be done via 2 methods:
        1) use anonymous params separated by spaces, like from command line:
            -> arrays_to_hash $keys_var $vals_var
        2) use named parameters which have been dot-sourced and will surface
            when using the hypen (which is more idiomatic):
            -> arrays_to_hash -keys $keys_var -vals $vals_var
   ---------------------------------------------------------------- #>
    $h = @{}
    if ($keys.Length -ne $vals.Length) {
        Write-Error -Message "Array lengths do not match" `
                    -Category InvalidData `
                    -TargetObject $vals
    } else {
        for ($i = 0; $i -lt $keys.Length; $i++) {
            $h[$keys[$i]] = $vals[$i]
        }
    }
    return $h
}