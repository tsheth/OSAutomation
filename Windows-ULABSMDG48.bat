net stop SAPMS2_00
net stop SAPMS2_01
net stop SAPTRH_02
net stop SYBSQL_MS2
net stop SYBBCK_MS2_BS


Start SAP control center

.\sapcontrol.exe -nr <instance_number> -function StartSystem

.\sapcontrol.exe -nr <instance_number> -function Start


Stop SAP control center

.\sapcontrol.exe -nr <instance_number> -function StopSystem

.\sapcontrol.exe -nr <instance_number> -function Stop




