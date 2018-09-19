$username = 'admin'
$password = 'Lucidworks1'
$auth = $username + ':' + $password
$headers = '@{"Authorization"="Basic '+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($auth))+'"}'
$justcommand = $MyInvocation.Line.Split(" ")[0].substring($myInvocation.OffSetInLine-1)
$therest = $MyInvocation.Line.Substring($justcommand.Length+1)  
$wholexp = 'Invoke-RestMethod -Headers '+ $headers + ' ' + $therest + ' -ContentType "application/json" | ConvertTo-Json'  
Invoke-Expression $wholexp