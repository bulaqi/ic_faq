### 1.如何评估一个平台的复杂度
1. 输入激励的个数，输入激励的类型，N->1 or 1->N
2. dut中是否存在多通道，不同通道之间的关系
3. 参考模型中有关仲裁,fifo缓存处理的处理，reset时要求，对正在处理数据，待处理数据的处理原则，reset的不同时机
4. dut内涉及时间的计算，如msix中断聚合的时间阈值+数量阈值
5. 控制reg的数量和控制策略


### 2.好平台的若干项措施
1. 平台拓宽,已有VIP获取数据，还是自己编写驱动获取
2. 不同组件如何获取DUT的全局配置,建议采用gloab.cfg文件,eg:通过ahb配置aem_region0_addr
	- 思路:可以建立一个全局的配置类,该类内包含全部寄存,内部组件需要任何寄存器的值都从该类内获取
   		1. 方法1: 平台可以通过监控总线数据,刷新该全局类的寄存器
   		2. 方法2: 用例之间写该配置类的值
     
3. 合理的用例结构,可以快速开发的用例
  - 采用原华为的用例模板,和当前开发各种seq结合的方法,快速构建用例
  - 如果seq发包需要用task 封装,请重复考虑传参的全面性,建议:
  	1. tc_cfg_struct_class 类,承载bit_map_en的用例控制结构图, 
    2. dut_cfg_seq类,传递配置信息 
    3. 一个控制发包seq的类,eg,顺序发,rand发,全部发等场景
  - 建议，快速的tranction, 先不写dut_cfg的随机和约束，而是将dut_cfg类无脑随机，加你个随机出来后的的句柄，再次调用urand定点赋值
  
5. 充分考虑开发平台的可测试性,按照功能将关键信息打印至不同文件中
  - 打印用例中的激励, 在transaction中实现print_函数
  - 打印配置,在配置tranaction内实现print函数,打印初始化, 在实际发送的seq打印下发给dut的配置
  - 打印rm中收到的报文数据
  - 打印scb exp act的数据
    
6. 借助脚本,效率会更高
  开发bscb,将scb组件中的收到的exp和act报文数据,用becompare比较，数据的比较也可以基于日志，将act,exp都打印到对应的日志中，调用shell 命令比较

7. 检查尽量黑盒测试,测试过程尽量不借助dut信号,确保scb中优先收到exp数据比act数据早。特殊情况，特殊处理，eg, 实际路是axi_stream, dut接受stream数据可以获取4dw，即可接受到1个CQE，就可以pipe的处理输出，而不是等该笔axi_stream包发文才处理，这样会导致dut输出早于rm输出

8. 严格按照VO表进行推进,欢迎有新想法,新想法可以先记录,完成计划任务后再补新idea,要详细开发和架构多轮评审的意义

9. dut全部的寄存 生成一个类,生成transaction;然后用该类生成dut_transaction

10. 平台数据的比较, dut的过程记录新建2个类exp类和act类,在env内,类型uvm_objection,在shut_down_phase 调用compare函数比较
    - exp类: 包含rm 计算值送入exp类,或者用例输入的类
    - act类: 包含dut接口寄存器和act 口输出的数据
    
11. 重复考虑功能覆盖率，将需要采集的数据封装成class, 通过tlm 传到 cov 组件

12. 平台搭建，考虑reset的时候复位，
	- 需要清理环境的全局统计数据，否则重启后数据对比失败
    - 需要复位清理环境的数据，可以存在就一个类内，重新new,即可以删除用例
    - 可以到reset流程可以是comom的组件或者方法

13. 典型seq， 需要尽可能的考虑到每次参数都可以被传参修改，细化约束

14.  reset平台需要重复考虑，是否是采用jump_phase 还是用run_phase 模块控制

15.  平台尽量通用传输，未使能的通道，请设计设计走特殊分支；

16. 合理分层设计， 激励seq 应该分层应该合理，尽量在可能得最顶层用不同的id参数隔离，子函数通过层层传递的参数并行工作， 注意下层都需要用automatic 修改task/function

17. 平台数据应该设计的尽量保序处理，如果是多通道的需要将不同的通道分开，保序的存入不同的队列，然后scb 对比
	- axi 数据，需要比较data,addr,序

18. scb 采用关联数组，字符串或者int作为索引，然后比较，首先根据索引find,然后才是调用uvm_compare 函数

19. rm 和平台很多内部的信号值和寄存器，可以的话尽量用后门获取，不一定非要前门，尤其是需要轮询等待的数据，否则bus会被占用，平台各自报错也较难处理

20. 寄存模型访问寄存器，如果涉及多个被访问对象（但是却是通过一组总线接访问）应该避免直接访问，read_reg/write_reg 数据尽量封装成再封装一层，RTL 寄存器模型代码修改后对平台代码的冲击

21. 如果需要不同参数传递不同的值，建议设置一个全局变量，在全局配置里或者interface上，在base_test中通过$test$args的不同参数,修改该全部变量，避免多处地方都需要$test$args 识别参考，减少后期的修改量
	- 宏的方法也类似

22. 验证思路的： 提前随机好路径，然后执行，避免过程中动态计算 ，能一次随机就不要多次随机，会影响效率【重要】
    - eg,ring acqe tail 应该提前回规划， 先确认需要ring的个数，然后随机出一组随机出，然后随机每次需要随机等待的时间，然后在随机等待的时间后，按照之前随机出的队列，进行随机
    
24. 随机n个数据和为sum的应用：随机的ring,随机的发送总长数据为N,但是burst 长度不定的axi stream transaction

25. 随机n个数据和为sum的实现：
    - 常规做法：移窗， 第一步先要随机出第一步的长度，然后求解left_num,为sum 后跳出 【不推荐】
    - sv类的随机： sum 求和， 先随机处理len，len个数据和为sum, 然后foreach 求解求出每个元素的值 【推荐】

26. reset时，req_req前，当前，后激励的处理，已经参考模型的理解
  - 背景：
    1. 一般是reset_req后，不再接收输入数据
    2. 当前处理的包，正常处理
    3. reset_req后的包，不再发送dam_req请求，丢包
    
  - 参考模型，和dut的逻辑保持一致的方法
    1. 因的dma_req前，dut有已收到的数据缓存
    2. 所以，需要拉内部信号，找到当前发送的具体包，然后将在scb的exp队列内找到该包，删除该包后续的包
    3. 参加模型的reset清理环境的逻辑的接口，需要特别注意，需要和dut保持一致，该信号可能不是端口上的信号/Reset_int信号,与实际起效的时间点有时间差

27. 检测对应的中断是否发生？非期望的中断是否未发送的实现思路：
  1. 设置中断检测逻辑（wait @posdege xx_int，前提打开了en,关闭mask），开关控制是否打开，一般用例默认打开该函数
  2. 中断用例，关闭该通用中断检查的开关，不检查
  3. 中断用例，要检查期望的中断发生，并且不该发生的中断不发送


28. 为什么不将中断复位程序作为组件，进行处理？中断响应程序+中断检查逻辑，是不同的的
  1. 组件实现：优点可以完全模拟中断复位程序，但是无法再中断组件中checker该发生的中断是否是对应的中断，已经status是否相同
  2. common_task，方便见中断复位程序和中断检测对应起来,灵活

29. 通用函数的可扩展性的思路，ctrl_mode作为枚举值，先加单场景，逐步到全部随机控制
  1. 设置ctrl_mode的入参，task根据该ctrol_mode实现不同的逻辑
  2. 调用函数根据业务需要，传入不同的参数

29. 多人协作的平台打印控制，通过$test$args，传入自定义run_option的debug_mode, 在base_test中通过debug_mode,灵活的根据ID控制uvm_info打印等级，和是否打印log文件，或者当前在调代码的屏蔽，避免个人的私有日志影响别人的仿真效率
	- 在Verbose是UVM_HIGH的的调试模式下，通过日志ID关闭VIP的UVM_HIGH的日志打印，仅保留平台自定义的类
    - 注意通过ID 动态调整某些VIP的打印等级，有时候不一定有效，因为部分类是继承自VMM,而非UVM
    
30. 在平台封装参数的时候，尽量用类，而不是结构体
	- 结构体非对象，在传参的时候地赋值，不能像类一样，通过ref传句柄，如果结构体内有太多变量，会影响方针效率
    - 类的时候，方便TLP传给COV组件，方便覆盖率的收集
    - 类，可以重新new,即可清理全部的原谅，而结构体不可以


### 3.好用例的若干项措施
1.  用例灵活的的注错方式，要求动态注错，override 或者是callback
2.  多次复位，需要在在第一次复位后，应该完整的传一次完整的数据，完全比对，确保一次过程强制复位不会影响后续的正常传输
3.  reset用例就应该考虑覆盖率 toggle的情况，尤其是aix addr的高bit翻转等，即adrr 应该从f->0, 0->f 都覆盖
4.  axi 反压情况，brsponse 和 bvalid等应该是动态大范围变化的，而不是被约束在某个范围内随机，参加vip约束的逻辑，2个constran,1个inside限制范围,1个dist,将在该范围内，分成3段，段的权重用宏控制权重
   

### 3. 传送门:
[we can do better](https://github.com/bulaqi/IC-DV.github.io/blob/main/doc/%5BTOP%5D%20we%20can%20do%20better.md)
