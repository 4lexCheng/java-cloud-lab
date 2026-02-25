# JDK + Maven version management (Windows)

## Current local versions
- JDK 8: `D:\java_dev\jdk1.8.0_281`
- JDK 17: `D:\java_dev\jdk17.0.6\jdk-17.0.6+10`
- Maven 3.6.1: `D:\Tools\apache-maven-3.6.1`
- Maven 3.9.9: `D:\IntelliJ\Idea\IntelliJ IDEA 2025.2.3\plugins\maven\lib\maven3`

## Why keep multi-version
- Old projects may depend on old Maven/JDK behavior.
- New projects (Spring Boot 3+) require JDK 17 and usually Maven >= 3.6.3.

## Session switch commands
```powershell
.\scripts\use-jdk8.ps1
.\scripts\use-jdk17.ps1
.\scripts\use-maven-3.6.1.ps1
.\scripts\use-maven-3.9.9.ps1
.\scripts\use-java17-maven399.ps1
```

## Recommended default for this project
```powershell
.\scripts\use-java17-maven399.ps1
mvn "-Dmaven.test.skip=true" clean package
```

## Verify active versions
```powershell
java -version
mvn -v
```
