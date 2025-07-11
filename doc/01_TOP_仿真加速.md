### 1. 知识点
#### 1. 仿真选项
1. 调试阶段关闭不必要的选项，xproc,jitter,cov，debug_access，时序检查（断言），关闭非必要的日志，reg_only 等，
2. 多核并行仿真：使用 -j 选项来指定处理器的数量以加速仿真。例如，-j4 表示使用4个处理器进行并行仿真。
3. 细粒度并行性 (FGP)：通过 -fgp 选项启用，可以与 -j 选项结合使用以进一步提升仿真速度。例如，vcs -fgp -full64 <otherOptions>% simv -fgp=num_threads:4,num_fsdb_threads:4
4. 减少打印日志，
5. 减少文件的操作
6. timesale
7. 断言
8. dump fsdb



#### 2. 仿真语言
1. 使用向量操作代替单bit操作：仿真器在做完整向量计算的速度比单bit计算要高，这可以显著提高仿真速
2. 避免在循环中进行不必要的计算：例如，循环条件中不要包含计算，与循环因子无关的计算应在循环外完成，避免在循环中进行数据引用。
3. 优化数据结构：使用结构体代替类，减少动态对象的创建和销毁，以减少内存管理开销。
4. 减少动态任务或函数的唤醒：动态任务或函数的执行可能导致仿真器禁用优化，尽量减少它们的执行
5. 减少条件判断和字符串处理：在UVM中使用 report 管理机制，根据 verbosity 等级判断是否需要打印信息或进行字符串格式处理。
6. 使用回调函数优化随机约束：使用 pre_randomize() 和 post_randomize() 函数避免低效的约束行为。
7. 合理使用阻塞和非阻塞赋值：避免在阻塞赋值语句的左侧或右侧放置延时，这可能导致仿真效率降低。
8. 优化仿真调度：理解 SystemVerilog 的 event-driven 仿真模型，优化事件处理以提高仿真速度。
9. 减少对函数/任务的调用：每次调用函数或任务都会操作堆栈数据，这可能导致仿真变慢，应尽量减少这类调用。
   
#### 3. 仿真控制
1. 使用 save/restore 机制：在仿真过程中定期保存状态，以便在出现问题时可以从最近的保存点恢复，而不必重新仿真。
2. check_point的使用

#### 4. 回归策略
1. 基础功能完成后，再打开dfx的选项
   
#### 5. 业务逻辑
1. 基础功能+ 性能 +  dfx

#### 4. 综合手段
1. 硬件仿真加速平台：使用如 Veloce 这样的硬件仿真加速平台，以提高仿真速度。
2. JVM 优化：更换 JVM 可以提高编译速度，例如使用 GraalVM 替代其他 JVM。
3. 分布式仿真：采用分布式仿真技术，可以显著提高仿真速度，尤其适用于带宽密集型应用

### 2. 经验
#

### 3. 传送门
1. [代码逻辑优化的梳理](https://github.com/bulaqi/IC-DV.github.io/blob/main/doc/01%20%E4%BB%BF%E7%9C%9F%E5%8A%A0%E9%80%9F_SV%E7%BC%96%E7%A0%81.md)
2. [vcs-accelerate](https://francisz.cn/2020/10/11/vcs-accelerate)
3. [验证仿真提速系列--SystemVerilog编码层面提速的若干策略](https://zhuanlan.zhihu.com/p/384492472)
4. [SystemVerilog仿真速率提升_vivado systemverilog仿真速度](https://blog.csdn.net/Michael177/article/details/125473167)
5. [DVCon-US-2020】以接口为中心的软硬件协同SoC验证](https://developer.aliyun.com/article/1072936)
6. [[SV]Verilog仿真中增加延时的方法总结及案例分析 - CSDN博客](https://blog.csdn.net/gsjthxy/article/details/106029996)
7. [为什么我的SystemVerilog仿真还是很慢？ - CSDN博客](https://blog.csdn.net/kevindas/article/details/107753486)
8. [SystemVerilog LRM 学习笔记 -- SV Scheduler仿真调度 ](https://blog.csdn.net/wonder_coole/article/details/82182850)
9. [使用 Veloce 加快网络 ASIC 验证速度 - Siemens Resource](https://resources.sw.siemens.com/zh-CN/white-paper-faster-network-verification-with-veloce)
10. [编译与仿真加速 - XiangShan 官方文档](https://xiangshan-doc.readthedocs.io/zh-cn/latest/tools/compile-and-sim/)
10 [：VCS：助力英伟达开启Multi-Die系统仿真二倍速 - Synopsys](https://www.synopsys.com/zh-cn/blogs/chip-design/vcs-multi-die.html)
