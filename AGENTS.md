# Repository Guidelines

## 语言与协作约定
- 本仓库 `AGENTS.md` 以中文为主，说明、示例、提交规范优先使用中文表达。
- 后续新会话执行 `/init` 时，默认按中文生成或更新 `AGENTS.md`。
- 如需英文文档，请在任务中明确说明“输出英文版本”。

## 项目结构与模块组织
- 主代码目录：`src/main/java/com/example/javacloudlab/`。
- 配置文件：`src/main/resources/application.yml`（当前主用）；若存在 `application.properties`，避免与 yml 同名键冲突。
- 测试目录：`src/test/java/`，包路径与主代码保持镜像结构。
- 本地环境切换脚本：`scripts/`（PowerShell）。
- 学习与操作文档：`docs/`（如 `docs/day1.md`）。
- 构建产物位于 `target/`，不要手工修改或提交。

## 构建、测试与本地运行
- `mvn clean package`：编译 + 测试 + 打包。
- `mvn test`：仅执行测试。
- `mvn "-Dmaven.test.skip=true" clean package`：跳过测试快速打包（仅本地临时验证）。
- `java -jar target/java-cloud-lab-0.0.1-SNAPSHOT.jar`：运行应用。
- `.\scripts\use-java17-maven399.ps1`：Windows 下推荐先切换到 JDK17 + Maven3.9.9。
- 启动后验证：
  - `GET /hello` 返回 `hello`
  - `GET /actuator/health` 返回 `{"status":"UP"}`

## 代码风格与命名规范
- 使用 Java 17+（`pom.xml` 已通过 Maven Enforcer 强校验）。
- 统一 4 空格缩进，遵循 Spring Boot 常规实践。
- 类名使用 `PascalCase`，方法/变量使用 `camelCase`。
- 包名全小写，例如 `com.example.javacloudlab`。
- 控制器只处理请求编排，业务逻辑优先下沉到 `service` 层。

## 测试与提交要求
- 测试框架：`spring-boot-starter-test`（JUnit 5）。
- 测试类命名：以 `Test` 结尾（如 `HelloControllerTest`）。
- 提交前至少运行一次 `mvn test`。
- 提交信息建议使用约定式前缀：`feat:`、`fix:`、`docs:`、`test:`、`refactor:`。
- PR 需包含：变更目的、关键改动、测试证据（命令或接口验证结果）、关联任务号（如有）。

## 每日 Git Tag 流程（约定）
- 本仓库使用脚本 `scripts/tag-day.ps1` 执行“每日提交 + 打 tag + 推送”。
- 远端仓库默认：`origin`，主分支默认：`main`。
- 每日标签命名默认：`day-XX-YYYYMMDD`（例如 `day-03-20260225`）。
- 在提交当日变更前，先更新 `docs/daily-study-playbook.md`：
  - 将对应 Day 标题标记为 `（已完成可跳过）`。
  - 在文末追加“今日踩坑速查（YYYY-MM-DD）”总结。
- 推荐优先使用注释标签（annotated tag），由脚本自动创建。
- 日常执行示例（提交、打标签并推送）：
  - `powershell -ExecutionPolicy Bypass -File .\scripts\tag-day.ps1 -Day 3 -Summary "多阶段构建与镜像对比" -CommitType feat`
- 仅本地提交和打标签（不推送）：
  - `powershell -ExecutionPolicy Bypass -File .\scripts\tag-day.ps1 -Day 3 -Summary "多阶段构建与镜像对比" -NoPush`
- 若用户要求“按每日流程提交并打 tag”，默认按以上脚本执行；除非用户明确指定，否则不改 `Remote/Branch/TagName` 规则。
- 用户明确要求“直接提权 push”时，可直接执行提权推送。
- 当前终端为 Windows PowerShell 5.1 时，避免使用 `&&`，改用分步命令执行。

## Dockerfile 修改输出约定
- 当用户要求修改 `Dockerfile` 时，必须提供以下信息：
  - 修改位置（文件路径 + 建议插入/替换位置）。
  - 可直接执行的 PowerShell 修改命令（优先给出完整可复制命令）。
- 若修改较大，优先提供完整 `Dockerfile` 内容，并同时附一条覆盖写入命令。
