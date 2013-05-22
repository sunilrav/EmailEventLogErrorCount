$smtp_server = "mail.xxxxxx.com"
$host_name = [System.Net.Dns]::GetHostName()
$from_email =  $host_name + "@xxxxxx.com"
$to_emails = @("one@xxxxxx.com, two@xxxxxx.com")
$apps = @("App1", "App2")
$errors_end_datetime = Get-Date
$errors_start_datetime = $errors_end_datetime.AddHours(-4)

function sendMail($content)
{
     #SMTP server name
     $smtpServer = $smtp_server

     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage

     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)

     #Email structure 
     $msg.From = $from_email
	 foreach ($to_email in $to_emails)
	 {
		$msg.To.Add($to_email)
	 }
     $msg.subject = "Error Summary after: " + $errors_start_datetime + ". Host: " + $host_name
     $msg.body = $content
	 $msg.IsBodyHtml = $true
     #Sending email 
     $smtp.Send($msg)
}

$email_content = "<div style='font-family: calibri'>";
$email_content += "<table style='font-family: calibri;' border='1'  cellpadding='0' cellspacing='0'>";
$email_content += "<tr>" + "<td>" + "<b>App Name</b>" + "</td>" + "<td>" + "<b>No. of errors</b>" + "</td>" + "</tr>"
foreach ($app in $apps)
{
	$error_count = 0;
	$error_count = (Get-EventLog $app | Where-Object {$_.EntryType -eq "Error" -and $_.TimeWritten -gt $errors_start_datetime}).count
	$email_content += "<tr>" + "<td>" + $app + "</td>" + "<td align='center'>" + $error_count + "</td>" + "</tr>"
}
$email_content += "</table>";
$email_content += "</div>";
sendMail $email_content

 

 