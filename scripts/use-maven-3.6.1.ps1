# Switch current PowerShell session to Maven 3.6.1
$env:MAVEN_HOME = 'D:\Tools\apache-maven-3.6.1'
$env:Path = "$env:MAVEN_HOME\bin;" + (($env:Path -split ';' | Where-Object { $_ -and ($_ -notmatch 'apache-maven-3\.6\.1\\bin|IntelliJ IDEA 2025\.2\.3\\plugins\\maven\\lib\\maven3\\bin') }) -join ';')
Write-Host "MAVEN_HOME=$env:MAVEN_HOME"
mvn -v
