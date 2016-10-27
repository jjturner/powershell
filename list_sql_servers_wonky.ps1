Import-Module sqlps -DisableNameChecking
get-childitem 'SQLSERVER:\sqlregistration\' -recurse| where {$_.GetType() -notlike '*ServerGroup*'} |
 Select servername, connectionstring |
   sort-object -property servername -unique |
     foreach-object {
         try
           {
           $conn = new-Object System.Data.SqlClient.SqlConnection($_.connectionstring)
           $conn.Open() | out-null
           }
         catch
           {"Could not connect to SQL Server instance '$_.servername': $($error[0].ToString() + $error[0].InvocationInfo.PositionMessage). Script is aborted"
                exit - 1
              }
 
         try {
            $cmd = new-Object System.Data.SqlClient.SqlCommand($sql, $conn)
            $rdr = $cmd.ExecuteReader()
            }
         catch
            {
            "Could not execute SQL batch '$sql': Error message received: $($error[0].ToString() + $error[0].InvocationInfo.PositionMessage). Script is aborted"
               exit - 1
            }
     }
 
While($rdr.Read()){
       "$($rdr['name']) on $($_.servername)"
      }