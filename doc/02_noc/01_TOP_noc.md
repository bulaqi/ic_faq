### 1. 基础知识
1. noc的死锁验证是通过架构和设计讨论，对路径的依赖分析，确认的，测试很难测试到是否有死锁存在（必须是大量的数据，并行，满载才有可能触发）

2. noc的端口的axi的ostd能力是可配置的，配置建议是，将该noc该端口的ostd能力和接入模块的ostd能力，木桶原理，资源不浪费，noc ostd的能力本身也是在内部有buff存在，ostd的设置和buffer的深度相关

3. 如果通过noc，同一个ID访问，访问不同的target, 因target可能是快、满设备，响应速度不同，则B通道是乱序的。 如果要在此种情况下，进行保序，必须在产noc开关的时候，打开noc 保序开关，代价是增加面积，影响效率，因为保序的实现是通过内部缓存实现的。 
	- 建议：不同的target，设置不同的axi  id

4. noc的超时机制，该机制是可选性，如果打开，发送数据后启动计时，计时超过配置阈值，代答。如果代答后目标端B通道握手，则timeout模块，会丢掉该B通道的握手。所以说，该timeout的模块是在整个通路总线上

5. noc的axi回复逻辑，输入aw,w 握手，b通道等待握手；待输出口将该axi 发给target, 出口等待targetb通道的握手，target在B通道握手后，noc 检测到，然后通过内部逻辑，才能输入口的axi的b通道握手

### 2. 经验
### 3. 传送门
1. [谈谈NoC Interconnect在复杂SoC设计中的应用 - 多核/异构系统的最佳互连方法](https://zhuanlan.zhihu.com/p/524040847)
2. [Arteris Training](https://blog.csdn.net/tiaozhanzhe1900/article/details/125772019)
3. [NOC总线架构拓扑介绍](https://xueying.blog.csdn.net/article/details/130214231?spm=1001.2014.3001.5502)
4. [NOC总线](https://blog.csdn.net/u010451780/article/details/123440223?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-123440223-blog-130214231.235%5Ev38%5Epc_relevant_yljh&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-123440223-blog-130214231.235%5Ev38%5Epc_relevant_yljh&utm_relevant_index=2)
5. http://10.180.116.29/svn/XIAN_Chip/九逸/02-架构设计/FlexNoC 
6. http://10.180.116.29/svn/XIAN_Chip/九逸/01-需求分析/IP供应商/Arteris 
