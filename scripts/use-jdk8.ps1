# Switch current PowerShell session to JDK 8
$env:JAVA_HOME = 'D:\java_dev\jdk1.8.0_281'
$env:Path = "$env:JAVA_HOME\bin;" + (($env:Path -split ';' | Where-Object { $_ -and ($_ -notmatch 'jdk') }) -join ';')
Write-Host "JAVA_HOME=$env:JAVA_HOME"
java -version
mvn -v
