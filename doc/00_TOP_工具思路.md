#### 1. 已有思路
1. icrun:
~~~
定时回归，
回归管理，
客户端（编译，仿真，vup适配，ui界面覆盖部分config信息）显示更多信息
~~~
2. ATB:
~~~
1. NOC ip soc hsio 适配，noc信息一致性检测，用户界面开发，icrun适配
2. ATB amba seq的自动开关用例
3. ATB clk reset 策略
4. 其他VIP适配
5. 定制化编译（dutmmy dut+ makefile）
6. 环境+编译+sanity用例
7. connetion检测
8. pareameter 参数对应TB
9. 寄存器模型的生成（需要考虑多份CSV例会）
10. simv
11. makefile管理
~~~

3. VMS:
~~~
1. VPA
	fast path生成
~~~    

4. DSM
~~~
待补充
~~~
	   
5. 其他：
~~~
定制化编译
命名规范
功能覆盖率->excel ->功能覆盖率定义-- 提取用例覆盖率形成最小的回归集合
vcs编译的option优化
	1. debug
	2. cell+lib
	3. c打印
	
	hvp不同文件夹用例合成一个hvp
~~~    
   
 ### 2. 个人总结发言
   ~~~
   ATB: 
        1. CR_VIP 直接接触到平台 & clk_jiterr
        2. 一种图像化的搭建测试平台ATB(组件的连接，tranaction的导入，vip的导入)

  基于表项的transaction 生成
  1. util工厂注册，包含元素域段的随机方式，边界的覆盖，权重，pack unpack，printf

  一种基于表单驱动的测试用例生成方法（对接口的测试AHB AXI AXI_stream等常用协议的eg,覆盖ostd,乱序，交织等）
      已表格的形式勾选功能点
   ~~~
   
    ### 3. 2025 头脑风暴
    1. 纪要
    ~~~
    覆盖率过滤：tie值
    代码编辑器，自动联想
    测试集，复用gouden 代码
    代码覆盖率100%，验证质量的评估
    asssert生成
    debug 放心
    文档撰写
    增强覆盖范围
    ~~~
    2. 思路
    ~~~
    0. 思路：解决重复劳动，释放人力，系统任务人为分解，模块任务工具逐步实现，glue 逻辑，头脑风暴，输出core场景覆盖
    1. 基础题（编译工具（自动联想） + 典型场景的测试模版 + AI） 

    2. 提高题(头脑风暴，竞争力)
    
    ~~~