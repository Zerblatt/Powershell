<#
Pust.ps1 
Ett skript som räknar antalet nollfiler på printservrar
19-08-30 Danne Andersson

Editera Servrar, sökväg och om det behövs ta bort
kommentaren på sista raden för att få en csv-fil med utfallet.

Följande ändringar görs
1; Ändra servrar i filen, var noga med att inte få med tomrader!!
2; Ändra sökväg typiskt C:\windows\system32\spool\PRINTERS
3; Ta bort kommentar för att få en txt-fil

#>

try
{
$filen="C:\ps-prod\KollaNoll\result.txt"

remove-item $filen -force

#Vi skapar vår array
$dataColl = @()#Makes an array, or a collection to hold all the object of the same fields.
foreach ($serverName in (get-content C:\Ps-prod\KollaNoll\servers.txt)) # 1
{
       $path = “\\$serverName\D$\EQSpool“ # 2
       
       $dirSize = Get-ChildItem $path -recurse -force | select Length  |Measure-Object -Sum length
       $dirSize.sum = $dirSize.sum/1MB
       $finalResult = “{0:N2} MB” -f $dirSize.sum
       $rakna = Get-ChildItem -Path $path -Recurse -Filter *.* | Where {$_.Length -eq 0} | measure-object | %{$_.count} 
      
             $dataObject = New-Object PSObject
       Add-Member -inputObject $dataObject -memberType NoteProperty -name “ServerName” -value $serverName
       Add-Member -inputObject $dataObject -memberType NoteProperty -name “Dir_Size” -value $finalResult
       Add-Member -inputObject $dataObject -memberType NoteProperty -name “Antal nollfiler” -value $rakna

       
       $dataColl += $dataObject  
       $dataObject
      
       
}
#$dataColl | Out-GridView -Title “Remote Directory Scan Results”
#$dataColl | Export-csv -noTypeInformation -path C:\Ps-prod\KollaNoll\result.csv # 3
$dataColl | out-file C:\Ps-prod\KollaNoll\result.txt

#Send-MailMessage -From 'Supercoder <dan-ake.andersson@dom.se>' -To 'dan-ake.andersson@dom.se' -Subject 'Dagens nollor' -Attachments .\result.txt -SmtpServer 'smtp.dom.se'
<#
function Send-SMTPmail($to, $from, $subject, $smtpServer, $body) {
    $mailer = new-object Net.Mail.SMTPclient($smtpServer)
    $msg = new-object Net.Mail.MailMessage($from, $to, $subject,
    $body)
    $msg.IsBodyHTML = $true
    $mailer.send($msg)
    $file = "c:\Ps-prod\KollaNoll\result.txt"
    $att = new-object Net.Mail.Attachment($file) 
    }

function Skicka-mail {
<#$username = "danaand"
$email = [adsisearcher]"(samaccountname=DOM\$username)"
$email = $email.FindOne().Properties.mail

Send-SMTPmail -to "dan-ake.andersson@dom.se" -from "dan-ake.andersson@dom.se" `
-subject "Dagens nollor" -smtpserver "smtp.dom.se" -body "Hej" Attachments.add'c:\Ps-prod\KollaNoll\result.txt'
   }
Skicka-mail
#>
$fromaddress = "Supercoder@dom.se" 
$toaddress = "dan-ake.andersson@dom.se" 
$Subject = "Dagens Nollor" 
$body = "Hej" 
$attachment = "C:\Ps-prod\KollaNoll\result.txt" 
$smtpserver = "smtp.dom.se" 

$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress)
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($attachment) 
$message.Attachments.Add($attach) 
$message.body = "Dagens Skörd !"
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message)



}

catch
{
    
    write-host "Här gick det visst åt skogen!!"
}
finally 
{
    ""
    write-host "Gick ju fint det här!"
}




