### 1. 知识点
1. VCS 在verdi_opts
 - 默认在打开某些配置配置
2. -f参数（运行参数）
- 仿真参数 -f filelist.f 可以将filelist.f文件中的内容直接加载到命令行。
- 常用于在运行选型中，将已加载配置文件
3. UVM_LOG_RECORD
- +UVM_LOG_RECORD 选项时，VCS 会创建一个或多个文件来存储仿真期间生成的日志信息。这些日志文件可以用来事后查看详细的运行情况，包括警告、错误以及任何通过 UVM 报告机制打印的信息
4. UVM_PY_MODE
- 当你想要启用VCS的Python协同仿真模式时，可以在编译或运行仿真时指定 +UVM_PY_MODE 选项

### 2. 经验总结

### 3. 传送门
1. [VCS 手册速查](https://zhuanlan.zhihu.com/p/614855173)
