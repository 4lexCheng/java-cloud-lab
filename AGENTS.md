# Repository Guidelines

## 语言与协作约定
- 本仓库 `AGENTS.md` 以中文为主，说明、示例、提交规范优先使用中文表达。
- 后续新会话执行 `/init` 时，默认按中文生成或更新 `AGENTS.md`。
- 如需英文文档，请在任务中明确说明“输出英文版本”。

## 项目结构与模块组织
- 主代码目录：`src/main/java/com/example/javacloudlab/`。
- 配置文件：`src/main/resources/application.properties`。
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
