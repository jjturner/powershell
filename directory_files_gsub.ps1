foreach ($file in gci $filepath -filter *.dtsx){ (gc "${filepath}\$file" ) -replace "Data Source=tpcsqlprd1\\prd",'Data Source=(local)'| set-content "${filepa
th}\$file" }