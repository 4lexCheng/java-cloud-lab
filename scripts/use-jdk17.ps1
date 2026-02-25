$env:JAVA_HOME = 'D:\java_dev\jdk17.0.6\jdk-17.0.6+10'
$env:Path = "$env:JAVA_HOME\bin;" + (($env:Path -split ';' | Where-Object { $_ -and ($_ -notmatch 'jdk') }) -join ';')
Write-Host "JAVA_HOME=$env:JAVA_HOME"
java -version
mvn -v
