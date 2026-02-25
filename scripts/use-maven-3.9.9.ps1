# Switch current PowerShell session to Maven 3.9.9 (IntelliJ bundled)
$env:MAVEN_HOME = 'D:\IntelliJ\Idea\IntelliJ IDEA 2025.2.3\plugins\maven\lib\maven3'
$env:Path = "$env:MAVEN_HOME\bin;" + (($env:Path -split ';' | Where-Object { $_ -and ($_ -notmatch 'apache-maven-3\.6\.1\\bin|IntelliJ IDEA 2025\.2\.3\\plugins\\maven\\lib\\maven3\\bin') }) -join ';')
Write-Host "MAVEN_HOME=$env:MAVEN_HOME"
mvn -v
