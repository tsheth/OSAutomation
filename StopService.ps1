$global:srv1 = $null
$global:srv2 = $null
$global:srv3 = $null
$global:srv4 = $null
$global:srv5 = $null
$global:status = $null

function FuncCheckService{
   param($ServiceName)  
   for ($i=0; $i -le 3; $i++){
      $arrService = Get-Service -Name $ServiceName
       if ($arrService.Status -eq "Running"){
            Stop-Service $ServiceName
        if($i -eq 3 -And $arrService.Status -eq "Running"){
            aws sns publish --topic-arn arn:aws:sns:us-east-1:662206690138:sapscript --message "Automation was not able to stop all the SAP service Kindly log in to the server and check the service"    
        
            echo "4 attampts failed to stop the service"
            return 0
        }
        }
    }
   return 1
}

function OverallStatus{
    param($statuscheck)
        echo "status checck is" $statuscheck
        if($statuscheck -ne 5){
        
        echo "there is a failure in service start no further execution"
          aws sns publish --topic-arn arn:aws:sns:us-east-1:662206690138:sapscript --message "Because of automation was not able to execute in server ULABSMDG48 we are aborting all further automation tasks for instance shutdown"                 
        return 0
    }
    Else{
                  
                aws lambda invoke --invocation-type RequestResponse --function-name AutoStop --region us-east-1 --log-type Tail outfile
		aws sns publish --topic-arn arn:aws:sns:us-east-1:662206690138:sapscript --message "All ther services are stoped hence we have turned on the ULABSMDG48 server"
		return 1
        }
}

$global:srv1 = FuncCheckService -ServiceName "SAPMS2_01"
$global:srv2 = FuncCheckService -ServiceName "SAPMS2_00"
$global:srv3 = FuncCheckService -ServiceName "SAPTRH_02"
$global:srv4 = FuncCheckService -ServiceName "SYBSQL_MS2"
$global:srv5 = FuncCheckService -ServiceName "SYBBCK_MS2_BS"

$global:status = ($global:srv1 + $global:srv2 + $global:srv3 + $global:srv4 + $global:srv5)

OverallStatus -statuscheck $global:status
