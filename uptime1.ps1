<# 
Uptime1.ps1
Ett skript som går igenom en lista av servrar 
och ser hur lÃ¤nge de varit uppe.

19-10-22 Danne Andersson 

Enklast möjliga editera server.txt så att just din server kommer med.
#>

remove-item "C:\Ps-prod\Uptime\uptime.txt" -force -ErrorAction SilentlyContinue

#Kan ju vara kul att ändra epostmottagere utan att behöva hacka i skripter
$epost= get-content "C:\Ps-prod\Uptime\epost.txt"


foreach ($serverName in (get-content C:\Ps-prod\Uptime\servers.txt)) 
{

# Dags att göra själva jobbet
$serverName |Out-File -Append C:\Ps-prod\Uptime\uptime.txt
Invoke-command  {systeminfo /s $servername | find "System Boot Time"| Out-File -Append C:\Ps-prod\Uptime\uptime.txt} -ErrorAction SilentlyContinue
Echo "---------------------------------------------------------------" |out-file -Append C:\Ps-prod\Uptime\uptime.txt 
}

$olle= get-Content "C:\Ps-prod\Uptime\uptime.txt" 
$nisse = Format-wide -Inputobject $olle |Out-String


$fromaddress = "PSguru@dom.se" 
$toaddress = $epost
$Subject = "Server Uptime status report" 
$body = "Hej" 
$attachment = "C:\Ps-prod\Uptime\uptime.txt" 
$smtpserver = "smtp.dom.se" 

$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress)
$message.IsBodyHtml = $false
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($attachment) 
$message.Attachments.Add($attach) 
$message.body = ""+ $nisse
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message)

remove-item "C:\Ps-prod\Uptime\uptime.txt" -force

