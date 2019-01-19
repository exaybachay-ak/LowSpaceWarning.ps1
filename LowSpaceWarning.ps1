### ---> Calculate disk total space and free space, then divide them and round the answer for readability later
$CDriveFree = get-wmiobject win32_logicaldisk | where-object deviceid -eq C: | select-object freespace
$CDriveSize = get-wmiobject win32_logicaldisk | where-object deviceid -eq C: | select-object size
$PercentFree = [math]::Round(($CDriveFree.freespace / $CDriveSize.size) * 100)
$FreeSpace = [math]::Round($CDriveFree.freespace / 1024 / 1024 / 1024)

### ---> If you have less than 15 percent free, email IT
if ($PercentFree -lt 15) {

	### ---> Email IT -- taken from https://github.com/exaybachay-ak/ServerBot/blob/master/serverBot.ps1
	# Make sure there is a directory to store secure creds in - create one if it doesn't exist
	if(!(Test-Path -Path C:\temp )){
	    New-Item -ItemType Directory -Force -Path C:\temp
	}

	# Receive creds from user and store as variable
	$username = "youremail@yourdomain.com"

	# Create a file to store your email password
	if(!(Test-Path -Path C:\temp\securestring.txt )){
	    read-host -assecurestring "Please enter your password" | convertfrom-securestring | out-file C:\temp\securestring.txt
	}
	$password = cat C:\temp\securestring.txt | convertto-securestring
	$mycreds = new-object -typename System.Management.Automation.PSCredential `
	         -argumentlist $username, $password

	Send-MailMessage -To "firstrecipient@yourdomain.com" -Cc "secondrecipient@yourdomain.com" -SmtpServer "smtp.office365.com" -Credential $mycreds -UseSsl "Server is low on space!!!!!!!!!!!!!!!!!!!!!!!" -Port "587" -Body "This is an automatically generated message.<br>Please check on the status of your server, as it appears to be low on space.<br> You may need to delete the contents of WinSXS, or add more storage to get it back up and running.<br>Best regards<br><b>Your Server Support Bot</b>" -From $username -BodyAsHtml

}
