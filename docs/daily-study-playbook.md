# Docker + K8s 每日实操手册（Java 版）

适用目录：`D:\k8s-study\java-cloud-lab`

## 使用方式
1. 每天先看对应 Day 的步骤。
2. 每一步都执行命令并记录结果。
3. 完成后在文末“打卡模板”写当天结论。

## 每天开始前固定动作（通用）
```powershell
cd D:\k8s-study\java-cloud-lab
.\scripts\use-java17-maven399.ps1
```
如果 IDEA 终端找不到 docker，先执行：
```powershell
$env:Path += ";C:\Program Files\Docker\Docker\resources\bin"
```

---

## Day 1（已完成可跳过）
目标：Spring Boot 最小应用可运行。
```powershell
mvn "-Dmaven.test.skip=true" clean package
java -jar target\java-cloud-lab-0.0.1-SNAPSHOT.jar
```
验收：
- `GET /hello` -> `hello`
- `GET /actuator/health` -> `{"status":"UP"}`

## Day 2（已完成可跳过）
目标：把应用放进 Docker 容器。
1. 打包 jar
```powershell
mvn "-Dmaven.test.skip=true" clean package
```
2. 创建 `Dockerfile`
```powershell
Set-Content -Path Dockerfile -Encoding Ascii -Value @(
'FROM eclipse-temurin:17-jre',
'WORKDIR /app',
'COPY target/*.jar app.jar',
'EXPOSE 8080',
'ENTRYPOINT ["java","-jar","app.jar"]'
)
```
3. 构建镜像并运行
```powershell
docker build -t java-cloud-lab:day2 .
docker run --rm -p 8080:8080 java-cloud-lab:day2
```
4. 新终端验收
```powershell
curl http://localhost:8080/hello
curl http://localhost:8080/actuator/health
```

## Day 3（已完成可跳过）
目标：多阶段构建（缩小镜像）。
说明：如果 Day 2 已经是“宿主机构建 jar + 运行时镜像只 COPY jar（不包含 Maven 与源码）”，那么改成多阶段后镜像体积可能不会明显变小；主要收益是构建环境一致性和可复现性。
1. 把 `Dockerfile` 改为多阶段：
```dockerfile
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn -Dmaven.test.skip=true clean package

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
```
2. 对比镜像大小
```powershell
docker build -t java-cloud-lab:day3 .
docker images | findstr java-cloud-lab
```

## Day 4（已完成可跳过）
目标：非 root 运行 + 健康检查。
1. 在运行阶段增加（按基础镜像选择其一）：
```dockerfile
# Debian/Ubuntu 系基础镜像（如 eclipse-temurin:17-jre）：
RUN groupadd --system app && useradd --system --gid app app

# Alpine 系基础镜像（如 eclipse-temurin:17-jre-alpine）：
RUN addgroup -S app && adduser -S -G app app

USER app
```
2. 健康检查说明：
- `eclipse-temurin:17-jre` 中通常不自带 `wget/curl`，直接写探针命令可能失败。
- 先确认镜像内探针工具可用，再启用健康检查，例如：
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost:8080/actuator/health || exit 1
```
3. 验证
```powershell
docker build -t java-cloud-lab:day4 .
docker run -d --name java-lab -p 8080:8080 java-cloud-lab:day4
docker inspect --format='{{.Config.User}}' java-lab
docker ps
docker rm -f java-lab
```

## Day 5（已完成可跳过）
目标：环境变量配置化。
1. 修改 `src/main/resources/application.yml`
```yaml
server:
  port: ${SERVER_PORT:8080}

spring:
  application:
    name: java-cloud-lab

management:
  endpoints:
    web:
      exposure:
        include: health,info
```
2. 若存在 `src/main/resources/application.properties`，删除或清空同名配置，避免冲突。
3. 验证
```powershell
docker build -t java-cloud-lab:day5 .
docker run --rm -e SERVER_PORT=8081 -p 8081:8081 java-cloud-lab:day5
curl http://localhost:8081/hello
```

## Day 6
目标：整理文档。
- 更新 `README.md`：启动、停止、常见问题。
- 新建 `docs/week1.md`：记录 3 个问题与结论。

## Day 7
目标：口述复盘。
- 镜像 vs 容器
- 为什么多阶段构建
- 为什么非 root 运行
- 质量门禁复核：执行一次 `mvn test`

## Day 8（已完成可跳过）
目标：接入 MySQL（本地先跑）。
- 加依赖：`spring-boot-starter-data-jpa`、`mysql-connector-j`
- 建一个最小实体 + Repository + 测试接口
- 本地直连 MySQL 验证
验收：
- 应用启动日志中无数据库连接异常（如 `Communications link failure`）。
- 至少 1 个读写接口可用（例如新增 + 查询）。
- 记录连接配置（host/port/db/user）与排障过程。

## Day 9
目标：Compose 跑通 app + mysql。
1. 创建 `docker-compose.yml`
2. 启动并看日志
```powershell
docker compose up -d --build
docker compose ps
docker compose logs -f app
```
验收：
- `docker compose ps` 中 `app`、`mysql` 都为 `Up`。
- 应用接口可访问，且能成功访问 MySQL。

## Day 10
目标：加入 Redis。
- compose 增加 `redis` 服务
- 应用加一个缓存接口（或 set/get）
验收：
- `docker compose ps` 中 `redis` 为 `Up`。
- 缓存接口至少验证一次写入和读取命中。

## Day 11
目标：排障演练。
```powershell
docker compose logs -f
docker exec -it <container_name> sh
docker network ls
docker network inspect <network_name>
```
演练：故意写错 mysql 主机名，再定位修复。
验收：
- 能明确定位故障在“配置/网络/服务可用性”中的哪一层。
- 输出一段可复用的排障步骤（不少于 5 条命令）。

## Day 12
目标：健康检查与依赖就绪。
- 为 mysql/app 配 healthcheck
- 确保应用启动稳定
验收：
- `docker compose ps` 显示健康状态（health）。
- 重启后应用不因依赖未就绪而启动失败。

## Day 13
目标：构建缓存进阶优化（BuildKit + 依赖预热）。
1. 启用 BuildKit，并使用缓存挂载优化 Maven 依赖下载。
2. 对比三组构建耗时：
- 首次冷启动构建
- 仅改业务代码后的增量构建
- 修改 `pom.xml` 后的构建
3. 记录每组耗时与关键日志，分析缓存命中效果。

## Day 14
目标：第1阶段验收。
```powershell
docker compose down -v
docker compose up -d --build
curl http://localhost:8080/hello
docker compose restart app
docker compose ps
mvn test
```

---

## Day 15-28（K8s 阶段执行入口）
你桌面已有详细打卡文件，按天执行：
- `C:\Users\song\Desktop\docker-k8s-study-plan-k8s-week3-4-checklist.md`
建议：将该清单同步一份到仓库 `docs/`，避免换机器或环境后无法继续执行。

每天固定命令模板：
```powershell
kubectl get all -n <ns>
kubectl apply -f k8s/ -n <ns>
kubectl logs -f deploy/<name> -n <ns>
kubectl describe pod <pod> -n <ns>
kubectl get events -n <ns> --sort-by=.lastTimestamp
```

## Day 29-84（后续阶段执行入口）
按桌面文件继续：
- `C:\Users\song\Desktop\docker-k8s-study-plan-week5-6-checklist.md`
- `C:\Users\song\Desktop\docker-k8s-study-plan-week7-8-checklist.md`
- `C:\Users\song\Desktop\docker-k8s-study-plan-week9-12-checklist.md`
建议：每个阶段至少保留一个仓库内摘要文档（目标、命令、验收、常见故障）。

---

## 每日打卡模板（复制到 docs/week-x.md）
```md
### Day X
- 目标：
- 完成项：
- 命令结果：
- 卡点：
- 明日计划：
- 构建耗时（首次/增量）：
- 镜像大小（tag + size）：
- 失败与重试次数：
```

---

## 今日踩坑速查（2026-02-24）
1. `docker` 命令找不到（`CommandNotFoundException`）
- 现象：`docker : 无法将“docker”项识别为 cmdlet...`
- 原因：Docker CLI 路径未生效，IDEA 终端常见是旧 PATH 快照。
- 处理：
```powershell
$env:Path += ";C:\Program Files\Docker\Docker\resources\bin"
docker version
```
- 长期：重启 IDEA 后再开终端。

2. Docker daemon 未启动（`npipe/docker_engine` 报错）
- 现象：`failed to connect to the docker API ... open //./pipe/docker_engine`
- 原因：Docker Desktop 未启动或引擎未就绪。
- 处理：
```powershell
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
docker version
```
- 看到 `Server:` 信息后再执行 `docker build`。

3. PowerShell 出现 `>>` 无法执行
- 现象：粘贴后终端提示符变成 `>>`。
- 原因：多行字符串（here-string）结束符不完整。
- 处理：按 `Ctrl + C` 退出后重输；或改用不会卡的写法：
```powershell
Set-Content -Path Dockerfile -Encoding Ascii -Value @(
'FROM eclipse-temurin:17-jre',
'WORKDIR /app',
'COPY target/*.jar app.jar',
'EXPOSE 8080',
'ENTRYPOINT ["java","-jar","app.jar"]'
)
```

4. Maven / JDK 版本不匹配
- 现象：Boot 3 构建失败、插件版本要求不满足。
- 原因：会话仍使用 JDK8 + Maven3.6.1。
- 处理（本项目固定）：
```powershell
.\scripts\use-java17-maven399.ps1
mvn "-Dmaven.test.skip=true" clean package
```

5. WSL 版本过旧导致 Docker Desktop 不可用
- 现象：`Your version of Windows Subsystem for Linux (WSL) is too old`
- 原因：WSL 内核版本不满足 Docker Desktop 要求。
- 处理：
```powershell
wsl --update
wsl --shutdown
```
- 然后重启 Docker Desktop（必要时重启电脑）。

6. `docker build` 拉基础镜像失败（oauth token / 连接被重置）
- 现象：`failed to fetch oauth token`、`wsarecv: An existing connection was forcibly closed...`
- 原因：到 Docker Hub 网络不稳定或代理配置异常。
- 处理顺序：
```powershell
docker pull eclipse-temurin:17-jre
docker build -t java-cloud-lab:day2 .
```
- 如果频繁失败：在 Docker Desktop 配置 `registry-mirrors` 后重试。

7. PowerShell 的 `curl` 输出对象过多（StatusCode/Headers/Forms）
- 现象：执行 `curl http://localhost:8080/hello` 显示很多字段，不是纯字符串。
- 原因：PowerShell 中 `curl` 是 `Invoke-WebRequest` 别名，返回对象。
- 处理（只看需要内容）：
```powershell
(curl http://localhost:8080/hello).Content
(Invoke-RestMethod http://localhost:8080/actuator/health).status
curl.exe http://localhost:8080/hello
```

## 今日踩坑速查（2026-02-25）
1. Day4 非 root 命令与基础镜像不匹配
- 现象：`groupadd/useradd` 或 `addgroup/adduser` 在镜像里报“命令不存在”。
- 原因：Debian/Ubuntu 与 Alpine 的用户管理命令不同。
- 处理：
```dockerfile
# 运行时镜像是 eclipse-temurin:17-jre（Debian/Ubuntu 风格）
RUN groupadd --system app && useradd --system --gid app app

# 运行时镜像是 eclipse-temurin:17-jre-alpine（Alpine 风格）
RUN addgroup -S app && adduser -S -G app app
```
- 关键：两套命令二选一，不要混用。

2. Day4 镜像比 Day3 稍大
- 现象：加了非 root 和健康检查后，镜像体积略增。
- 原因：新增了 `RUN` 层（创建用户/改权限）和镜像元数据（`HEALTHCHECK`），属于预期现象。
- 处理：这是用少量体积换安全性与可观测性，通常可以接受。

3. 容器显示 `Exited (130)`
- 现象：`docker ps -a` 中状态是 `Exited (130)`。
- 原因：通常是前台运行时按了 `Ctrl + C`，对应 SIGINT 中断退出。
- 处理：这不一定是程序错误；重新启动可用：
```powershell
docker start <container_name>
```

4. 用了 `--rm` 后容器无法再次 `start`
- 现象：停止后找不到容器，`docker start` 失败。
- 原因：`--rm` 会在容器停止后自动删除容器。
- 处理：
```powershell
# 想保留容器用于复查时，不要加 --rm
docker run -d --name java-lab -p 8080:8080 <image>
```

5. 进入容器后退出时误停容器
- 现象：退出交互会话后，容器被停止。
- 原因：使用了 `docker attach`，退出时可能中断主进程。
- 处理：排查场景优先使用 `docker exec`：
```powershell
docker exec -it <container_name> sh
# 在容器内完成操作后执行 exit，只退出会话，容器继续运行
```

## 今日踩坑速查（2026-02-27）
1. `DB_URL` 被换行导致 JDBC URL 非法
- 现象：启动时出现 `Driver com.mysql.cj.jdbc.Driver claims to not accept jdbcUrl`，并伴随 `HHH000342`。
- 原因：PowerShell 多行赋值把换行和空格写进了连接串。
- 处理：`DB_URL` 必须一行写完：
```powershell
$env:DB_URL="jdbc:mysql://127.0.0.1:3307/java_cloud_lab?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
```

2. PowerShell 下 `curl.exe` JSON 转义错误导致 400
- 现象：`POST /api/todos` 返回 `400 Bad Request`，并出现 `URL rejected` / `Bad hostname`。
- 原因：使用了 `cmd` 风格转义（`\\"`），PowerShell 参数被拆乱。
- 处理：使用单引号 JSON 或 `Invoke-RestMethod`：
```powershell
curl.exe -X POST "http://localhost:8080/api/todos" -H "Content-Type: application/json" --data-raw '{"title":"day8 done"}'
```

3. MySQL 8 服务注册被拒绝（非管理员终端）
- 现象：注册服务时报 `Install/Remove of the Service Denied!`。
- 原因：当前终端不具备管理员权限。
- 处理：先用进程模式启动，后续在管理员终端注册服务：
```powershell
"D:\mysql\versions\8.4.8\mysql-8.4.8-winx64\bin\mysqld.exe" --defaults-file="D:\mysql\conf\my-8.4.8.ini" --console
```

4. `root@localhost` 可用但 `127.0.0.1` 无法连接
- 现象：TCP 登录报 `Host '127.0.0.1' is not allowed to connect`。
- 原因：账号主机匹配未覆盖 `127.0.0.1`。
- 处理：补齐 `root@127.0.0.1` 授权并重验连接。
