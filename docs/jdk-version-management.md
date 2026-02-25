# JDK version management (Windows + Maven)

## Why this exists
This project requires **JDK 17+** (enforced by `maven-enforcer-plugin`).
If Maven uses JDK 8 by mistake, build will fail early with a clear message.

## 1) Check which JDK Maven is using
```powershell
java -version
javac -version
mvn -v
```
Focus on `mvn -v` output, because Maven can differ from your shell `java`.

## 2) Quick switch in current PowerShell session
```powershell
.\scripts\use-jdk8.ps1
.\scripts\use-jdk17.ps1
```
Note:
- `use-jdk17.ps1` is preconfigured to `D:\java_dev\jdk17.0.6\jdk-17.0.6+10` on your machine.
- If that path changes later, update the script.

## 3) Optional: Maven Toolchains (recommended for multi-project work)
1. Copy `toolchains/toolchains.example.xml` to `%USERPROFILE%\.m2\toolchains.xml`.
2. Adjust `<jdkHome>` paths to your machine.
3. Keep both JDK 8 and JDK 17 entries for old/new projects.

## 4) Build this project
```powershell
mvn "-Dmaven.test.skip=true" clean package
```
If you see Java version mismatch, run `use-jdk17.ps1` first.
