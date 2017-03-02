$global:srv1 = $null
$global:srv2 = $null
$global:srv3 = $null
$global:srv4 = $null
$global:srv5 = $null
$global:srv6 = $null
$global:status = $null

function FuncCheckService{
   param($ServiceName)  
   for ($i=0; $i -le 3; $i++){
      $arrService = Get-Service -Name $ServiceName
       if ($arrService.Status -ne "Running"){
            Start-Service $ServiceName
        if($i -eq 3 -And $arrService.Status -ne "Running"){
            aws sns publish --topic-arn arn:aws:sns:us-east-1:662206690138:sapscript --message "SAP service was not able to start in ULABSMDG48 server kindly log in to the server and check the service"  
        
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
        if($statuscheck -ne 6){
        echo "there is a failure in service start no further execution"
                aws sns publish --topic-arn arn:aws:sns:us-east-1:662206690138:sapscript --message "SAP service was not able to start hence we have stoped all further automation for the ULABSMDG48 server"
        return 0
    }
}

$global:srv1 = FuncCheckService -ServiceName "SAPMS2_01"
$global:srv2 = FuncCheckService -ServiceName "SAPMS2_00"
$global:srv3 = FuncCheckService -ServiceName "SAPTRH_02"
$global:srv4 = FuncCheckService -ServiceName "SYBSQL_MS2"
$global:srv5 = FuncCheckService -ServiceName "SYBBCK_MS2_BS"
$global:srv6 = FuncCheckService -ServiceName "SAPMSR_04"

$global:status = ($global:srv1 + $global:srv2 + $global:srv3 + $global:srv4 + $global:srv5 + $global:srv6)

OverallStatus -statuscheck $global:status
