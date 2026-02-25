# One-shot: JDK 17 + Maven 3.9.9 for this project
$env:JAVA_HOME = 'D:\java_dev\jdk17.0.6\jdk-17.0.6+10'
$env:MAVEN_HOME = 'D:\IntelliJ\Idea\IntelliJ IDEA 2025.2.3\plugins\maven\lib\maven3'
$cleaned = ($env:Path -split ';' | Where-Object {
    $_ -and ($_ -notmatch 'jdk') -and ($_ -notmatch 'apache-maven-3\.6\.1\\bin|IntelliJ IDEA 2025\.2\.3\\plugins\\maven\\lib\\maven3\\bin')
}) -join ';'
$env:Path = "$env:JAVA_HOME\bin;$env:MAVEN_HOME\bin;" + $cleaned
Write-Host "JAVA_HOME=$env:JAVA_HOME"
Write-Host "MAVEN_HOME=$env:MAVEN_HOME"
java -version
mvn -v
