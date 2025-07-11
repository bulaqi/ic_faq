### 1. 常用操作
#### 1. 添加波形,add_wave xxx.xxx.single
#### 2. 添加checkpoint, checkpoint -add "checkpoint_1"
#### 3. 运行,run
#### 4. stop
#### 5. 自动加载rc 文件,  wvRestoreSignal xx.rc
#### 6. 常用命令示例
~~~
1.open_db
2.close_db
3.open_file
4.start
5.step
6.next
7.run
8.finish
9.restart
10.stop
11.add_source
12.get
13.force
14.release
15.add_list
16.add_watch
17.add_wave
18.delete_group
19.delete_watch
20.delete_wave
21.compare
22.dump
23.memory
24.save
25.restore
26.save_session
27.open_session
28.config
~~~
#### 7. 常用举例
~~~
dump -add {aem_top_tb} -depth 0 -scope "." -aggregates
checkpoint -add "init"
run 1ps
add_wave aem_top_tb.th.dut_inst.aem_core_clk_i #添加信号波形
# force xxx.xxx.xxx 'h70000 -cancel 350us  // 350us 后取消，注意16进制数字必须是'hff 而不是0xfff
# force xxx.xxx.xxx 'h70000  -freeze //保持，未使用过
# force {xxx.xx.xx.xx.addr[63:0]} 'h0777 -deposit //信号有位宽，必须用大括号括起来
checkpoint -add "init 1"
run 10ns
checkpoint -add "init 10ns"
run
~~~

### 2. 经验
#### 1. 在 Tcl 脚本中使用 add_wave 命令时，波形路径中的中括号 [ ] 需要特殊处理，因为它们在 Tcl 中是命令替换符号。解决方案
1. 方法 1：反斜杠转义（推荐）
~~~
# 对每个中括号进行转义
add_wave {top.inst\[0\].data}          # 静态索引
add_wave "top.inst\[$index\].signal"   # 动态索引
~~~
2. 方法 2：花括号 {} 包裹整个路径（无变量时）
~~~
# 整个路径用花括号包裹，禁止命令替换
add_wave {top.inst[0].data} 
~~~
3. 方法 3：双引号 + 反斜杠转义（含变量时）
~~~
set index 5
add_wave "top.inst\[$index\].signal"  # 转义中括号 + 变量替换
~~~
4. 方法 4：使用 \][\] 转义序列
~~~
# 更清晰的转义方式
add_wave top.inst\][0\].data  # 注意 ] 前的反斜杠
~~~

### 3. 传送门
   参考ucli_ug.pdf
