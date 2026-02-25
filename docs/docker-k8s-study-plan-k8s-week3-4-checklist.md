# Kubernetes 学习打卡清单（第3-4周，14天）

使用方式：每天完成后把 `[ ]` 改成 `[x]`，并在“结果记录”写 2-3 行结论。
目标：完成从 Docker Compose 到 Kubernetes 的迁移，具备基础部署、升级、排障能力。

## 第3周：K8s 核心对象入门

### Day 15
- [ ] 安装并验证 `kubectl`、`kind`
- [ ] 创建本地集群并查看节点
- [ ] 熟悉 namespace 基本命令
结果记录：
- 

### Day 16
- [ ] 编写最小 Pod YAML 并部署
- [ ] 使用 `kubectl logs` 查看日志
- [ ] 使用 `kubectl describe pod` 查看事件
结果记录：
- 

### Day 17
- [ ] 编写 Deployment（副本数 2）
- [ ] 验证 Pod 副本自动拉起
- [ ] 练习 `kubectl rollout status`
结果记录：
- 

### Day 18
- [ ] 编写 Service（ClusterIP）
- [ ] 通过集群内 DNS 名访问服务
- [ ] 验证 Service 与 Pod 标签匹配关系
结果记录：
- 

### Day 19
- [ ] 使用 ConfigMap 管理配置
- [ ] 使用 Secret 管理敏感信息
- [ ] 在应用中读取配置并生效
结果记录：
- 

### Day 20
- [ ] 为应用添加 readiness/liveness probe
- [ ] 故意制造探针失败并观察重启
- [ ] 修复探针参数并恢复稳定
结果记录：
- 

### Day 21
- [ ] 为 Deployment 添加 requests/limits
- [ ] 观察资源限制行为
- [ ] 总结 Java 容器资源配置建议
结果记录：
- 

## 第4周：迁移实战 + 滚动升级 + 排障

### Day 22
- [ ] 将 app 的 compose 配置迁移到 K8s Deployment/Service
- [ ] 把环境变量迁移为 ConfigMap/Secret
- [ ] 部署后验证 `/hello` 可访问
结果记录：
- 

### Day 23
- [ ] 部署 MySQL（开发环境可先用单实例）
- [ ] 配置 PVC（如使用本地存储类）
- [ ] 验证重建 Pod 后数据仍在
结果记录：
- 

### Day 24
- [ ] 将应用接入 MySQL 服务名
- [ ] 完成一次读写验证
- [ ] 记录连接失败时的排障步骤
结果记录：
- 

### Day 25
- [ ] 执行镜像版本升级（v1 -> v2）
- [ ] 观察滚动升级过程
- [ ] 执行一次回滚并验证
结果记录：
- 

### Day 26
- [ ] 演练故障1：配置错误（ConfigMap）
- [ ] 演练故障2：端口错误（Service/ContainerPort）
- [ ] 演练故障3：探针阈值不合理
结果记录：
- 

### Day 27
- [ ] 按“现象-原因-修复”写故障复盘文档
- [ ] 将常用命令整理到 README
- [ ] 让环境可一键重建并部署
结果记录：
- 

### Day 28
- [ ] 阶段验收：删除命名空间后完整重建
- [ ] 验收：应用可用、配置可控、升级可回滚
- [ ] 完成第3-4周总结（下一阶段目标）
结果记录：
- 

## 通用命令清单（可复制）
```bash
kubectl get all -n <ns>
kubectl apply -f k8s/ -n <ns>
kubectl delete -f k8s/ -n <ns>
kubectl logs -f deploy/<name> -n <ns>
kubectl describe pod <pod> -n <ns>
kubectl get events -n <ns> --sort-by=.lastTimestamp
kubectl rollout status deploy/<name> -n <ns>
kubectl rollout history deploy/<name> -n <ns>
kubectl rollout undo deploy/<name> -n <ns>
```

## 第3-4周验收结论
- [ ] 我能独立写 Deployment/Service/ConfigMap/Secret
- [ ] 我能给 Java 服务加探针和资源限制
- [ ] 我能执行滚动升级与回滚
- [ ] 我能通过 logs/describe/events 快速定位常见问题
- [ ] 我有可复现的迁移与排障文档
