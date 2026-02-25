# Java 开发者 Docker + Kubernetes 学习计划（12周）

## 背景与目标
你当前工作中有一键部署平台，缺少底层实操机会。这个计划的核心是：用本地实验环境补齐 Docker/K8s 的工程实践能力。

12 周后目标：
1. 能独立把 Spring Boot 服务容器化并发布镜像。
2. 能在 Kubernetes 完成部署、滚动升级、基础排障。
3. 能用 Helm 管理多环境配置并回滚版本。
4. 能搭建基础 CI/CD（测试环境自动构建与部署）。
5. 能完成一个可演示项目：Spring Boot + MySQL + Redis + K8s + Ingress + 监控。

## 学习原则
- 每周固定 5-7 小时，持续投入优先。
- 每个知识点必须有产物：`Dockerfile`、`docker-compose.yml`、`k8s/*.yaml`、`helm chart`、`README`。
- 顺序必须是：容器 -> 编排 -> 工程化，不要反过来。
- 以 Java/Spring Boot 为主线，不做纯理论学习。

## 环境准备（第0周，半天）
1. 安装 Docker Desktop（或 Docker + WSL2）。
2. 安装本地 K8s：推荐 kind。
3. 安装工具：`kubectl`、`helm`、`k9s`（可选）。
4. 创建仓库：`java-cloud-lab`，建议目录：
   - `app/`
   - `docker/`
   - `k8s/`
   - `helm/`
   - `scripts/`
   - `docs/`

## 12周分阶段计划

### 第1-2周：Docker 基础 + Java 容器化
学习点：
- 镜像、容器、网络、数据卷、分层缓存
- Dockerfile 最佳实践（多阶段构建、非 root、健康检查）

实操任务：
- Spring Boot 项目打包镜像
- `docker compose` 跑通 `app + mysql + redis`
- 对比优化前后镜像体积与构建速度

验收标准：
- `docker compose up -d --build` 可一键启动
- 数据卷生效（重启容器数据不丢）
- 能解释 Dockerfile 每一层作用

### 第3-4周：K8s 核心对象
学习点：
- Pod、Deployment、Service、ConfigMap、Secret、Namespace
- liveness/readiness probe、requests/limits

实操任务：
- kind 建本地集群
- 将 compose 迁移为 K8s YAML
- 实现配置注入、探针、滚动发布

验收标准：
- `kubectl apply -f` 可完整部署
- 滚动升级不中断
- 能用 `kubectl logs/describe/events` 定位问题

### 第5-6周：流量与存储
学习点：
- Ingress、Service 暴露方式
- PV/PVC 持久化基础

实操任务：
- 部署 ingress-nginx
- 配置本地域名访问
- MySQL 使用 PVC

验收标准：
- 浏览器可通过域名访问服务
- 重建 Pod 后数据仍保留

### 第7-8周：可观测性与故障演练
学习点：
- 指标、日志、告警基础
- Prometheus + Grafana 入门

实操任务：
- Spring Boot Actuator + Micrometer
- 部署 Prometheus/Grafana
- 演练 3 类故障：CPU 打满、探针失败、配置错误

验收标准：
- 可观测 QPS/延迟/JVM 指标
- 每次故障有复盘：现象-原因-修复

### 第9-10周：Helm
学习点：
- Chart 模板化、values 覆盖、版本管理

实操任务：
- 将 K8s YAML 改造成 Helm Chart
- 提供 `values-dev.yaml`、`values-test.yaml`

验收标准：
- 一条 Helm 命令部署不同环境
- 能回滚到上一版本

### 第11-12周：CI/CD
学习点：
- 构建、测试、镜像推送、部署的流水线串联

实操任务：
- GitHub Actions 或 GitLab CI 实现：
  - `mvn test`
  - build image
  - push registry
  - deploy to test env

验收标准：
- 提交自动触发流水线
- 失败自动阻断发布
- 最终项目 README 和架构图完整

## 前2周每日打卡清单（可直接执行）

### 第1周
- Day1：创建最小 Spring Boot 应用，提供 `/hello`
- Day2：写单阶段 Dockerfile，镜像运行成功
- Day3：改为多阶段构建，观察镜像体积变化
- Day4：增加非 root 用户、HEALTHCHECK
- Day5：环境变量参数化配置
- Day6：整理 `docs/week1.md`
- Day7：复盘与口述自测

### 第2周
- Day8：应用接入 MySQL（本地验证）
- Day9：`docker-compose.yml` 跑通 app + mysql
- Day10：加入 redis 并做缓存验证
- Day11：网络与依赖排障演练
- Day12：健康检查与启动顺序优化
- Day13：构建缓存优化，比较构建时长
- Day14：阶段验收与 README 完善

## 每周执行模板
1. 工作日：每天 60 分钟
   - 30 分钟理论
   - 30 分钟命令实操
2. 周末：3 小时
   - 2 小时本周实验
   - 1 小时复盘文档

复盘固定回答：
- 本周完成了什么
- 卡点在哪里
- 下周怎么验证自己真的会了

## Java 方向重点加分项
- JVM 容器内存参数与 `-Xms/-Xmx` 配置
- Spring Boot liveness/readiness 健康探针
- 优雅停机：`preStop` + `terminationGracePeriodSeconds`
- JSON 结构化日志，便于接入 ELK/Loki

## 最小启动任务（今天就能做）
1. 新建一个 Spring Boot `/hello` 接口
2. 写 Dockerfile（多阶段）并启动容器
3. 用 compose 加 MySQL 并完成连接
4. 写一页 README（启动、停止、常见报错）

---
这个计划的核心不是“看完文档”，而是“每周都留下能跑起来的工程产物”。
