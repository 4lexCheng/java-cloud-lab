# Docker + Kubernetes 学习打卡清单（14天）

使用方式：每天完成后把 `[ ]` 改成 `[x]`，并在“结果记录”写 2-3 行结论。

## 第1周：Java 容器化

### Day 1
- [ ] 创建 Spring Boot 项目（Web + Actuator）
- [ ] 增加 `GET /hello`
- [ ] 本地运行验证 `/hello` 与 `/actuator/health`
结果记录：
- 

### Day 2
- [ ] 编写单阶段 Dockerfile
- [ ] 打包并运行容器
- [ ] `curl` 验证接口可访问
结果记录：
- 

### Day 3
- [ ] 改为多阶段构建 Dockerfile
- [ ] 对比优化前后镜像大小
- [ ] 验证功能无回归
结果记录：
- 

### Day 4
- [ ] 配置非 root 用户运行
- [ ] 增加 HEALTHCHECK
- [ ] 检查容器健康状态
结果记录：
- 

### Day 5
- [ ] 配置环境变量（端口/日志级别）
- [ ] 通过 `-e` 注入变量运行
- [ ] 验证配置生效
结果记录：
- 

### Day 6
- [ ] 整理 `docs/week1.md`
- [ ] 记录 3 个问题与解决方法
- [ ] README 可让他人复现
结果记录：
- 

### Day 7
- [ ] 口述自测：镜像/容器区别
- [ ] 口述自测：多阶段构建价值
- [ ] 口述自测：为何非 root 运行
结果记录：
- 

## 第2周：compose 多容器实战

### Day 8
- [ ] 应用接入 MySQL（本地）
- [ ] 完成一次读写验证
- [ ] 确认连接参数可配置
结果记录：
- 

### Day 9
- [ ] 编写 `docker-compose.yml`（app + mysql）
- [ ] `compose up -d --build` 成功
- [ ] 验证 volume 持久化
结果记录：
- 

### Day 10
- [ ] 加入 redis 服务
- [ ] 应用接入 redis
- [ ] 增加一个缓存验证接口
结果记录：
- 

### Day 11
- [ ] 故意制造连接错误并定位
- [ ] 使用 logs/exec/network inspect 排障
- [ ] 10 分钟内恢复服务
结果记录：
- 

### Day 12
- [ ] 增加服务健康检查
- [ ] 优化启动顺序（避免未就绪失败）
- [ ] 连续重启验证稳定性
结果记录：
- 

### Day 13
- [ ] 优化 Docker 构建缓存
- [ ] 记录优化前后构建耗时
- [ ] 总结缓存命中策略
结果记录：
- 

### Day 14
- [ ] 阶段验收：完整重建并启动
- [ ] 验收：app/mysql/redis 均可用
- [ ] 完善 README（启动、停止、常见报错）
结果记录：
- 

## 通用排障命令（可复制）
```bash
docker compose ps
docker compose logs -f
docker exec -it <container_name> sh
docker network ls
docker network inspect <network_name>
```

## 两周验收结论
- [ ] 我可以独立写生产向 Dockerfile（多阶段、非 root、健康检查）
- [ ] 我可以独立编排 app + mysql + redis
- [ ] 我可以定位并修复常见容器化故障
- [ ] 我有完整可复现文档
