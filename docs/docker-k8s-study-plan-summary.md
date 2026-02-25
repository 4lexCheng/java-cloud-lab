# Docker + Kubernetes 学习计划（1页精简版）

## 目标（12周）
1. 独立完成 Spring Boot 容器化并发布镜像。
2. 在 Kubernetes 完成部署、滚动升级、基础排障。
3. 使用 Helm 管理多环境配置与版本回滚。
4. 搭建基础 CI/CD，实现测试环境自动构建与部署。

## 学习路径
- 第1-2周：Docker 与 compose（app + mysql + redis）
- 第3-4周：K8s 核心对象（Pod/Deployment/Service/ConfigMap/Secret）
- 第5-6周：Ingress 与持久化（PVC）
- 第7-8周：监控与故障演练（Prometheus/Grafana）
- 第9-10周：Helm 模板化与多环境配置
- 第11-12周：CI/CD 串联（test -> image -> deploy）

## 每周投入
- 5-7 小时
- 工作日：每天 60 分钟（30 分理论 + 30 分实操）
- 周末：3 小时（2 小时实验 + 1 小时复盘）

## 每周产物
- 可运行代码
- Dockerfile / compose / k8s yaml / Helm chart
- `docs/week-x.md` 复盘文档

## 阶段验收标准
1. 一条命令启动（compose 或 kubectl/helm）。
2. 能独立定位常见故障（配置、网络、服务未就绪）。
3. 文档可复现（新同事 10 分钟跑起来）。

## 今日最小启动任务
1. 创建 Spring Boot `/hello` 接口。
2. 写多阶段 Dockerfile 并运行。
3. 用 compose 接入 MySQL。
4. 写 README（启动、停止、排障命令）。
