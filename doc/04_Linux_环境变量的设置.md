### 1. 基础知识
#### 1. setenv命令介绍
 - setenv是csh的命令; 在bash中是没有setenv
 - 查看环境变量
  ~~~
    echo $MYVAR // 加$是因为echo 命令需要知道是变量还是字符串 
  ~~~
 - 删除环境变量
  ~~~
  unsetenv MYVAR //注意：删除的时候不需要$符号，因为unsetenv和echo 命令不同，unsetenv可以直接识别环境变量
  ~~~
#### 2. export
1. Linux export命令是一个内置的Bash shell命令，用于将环境变量导出到子进程，而不影响现有的环境变量。本地shell变量只能被创建它们的shell所知道，如果开始一个新的shell会话，之前创建的变量就会对它不可见。
2. 所以在centos系统，export 只能在.cshrc等文件内使用，不能在c_shell调用

### 2. 经验

### 3. 传送门
1. [Linux setenv命令教程：如何在Linux中设置环境变量(附实例详解和注意事项)](https://blog.csdn.net/u012964600/article/details/137361499)
2. [linux配置csh设置环境变量](https://blog.csdn.net/matchbox1234/article/details/107822693)