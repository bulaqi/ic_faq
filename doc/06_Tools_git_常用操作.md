[TOC]
### 0. 概述
  git 新建分支的目的是为了多分支并行独立开发，完成后merger 到主分支

### 1.切分支查看,必须保持现场,不止add
#### 1.1 git commit 暂存,修改后回退
~~~
1. git add .
2. git commit -m "save tmp"
4. 查看代码
5. git checkout aem // 切回原分支
6. git reset --soft HEAD^  //回退已commit 但未push的
7. git reset HEAD <fiel>   // 回退已经add,但是未commit的
8. git fetch --tags  //只更新tags
9. git log --oneline //使用 --oneline 参数后，git log 信息会变得非常简洁，默认只展示简短的 commit id 和提交注释
~~~
#### 1.2 stash 暂存
~~~
git branch  // 查看当前分支
git status //查看修改文件
git stash // 将本地改动暂存到“栈”里面
git checkout master // 切换到master分支
git pull // 拉取master分支最新的代码
# 当我们再想切换回当前的feature分支
git checkout feature // 切换回到feature分支
git stash show //显示当前放在栈里的文件
git stash pop // 再将刚才暂存到“栈”里面的代码取出来
git status //此时查看就出现了暂存前修改文件
git add  .    git commit --amend    git push origin HEAD:refs/for/master  //第二次提交如上操作，不会产生新的commit_id
~~~
  
### 2. 常用命令
~~~
1. git checkout -b develop origin/develop  //本地新建分支,并关联远端分支 [强烈推荐使用]
2. git stash list
3. git branch -vv //查看当前的本地分支与远程分支的关联关系
4. git remote -v  //当前分支所属的远程仓库地址
5. git branch -d <branchname> //删除分支
6. git checkout -b <branchname>  //新建并切换至新分支,不影响远本地未add的数据
6. git stash VS  git stash pop
7. git pull -r --autostash
8. git show tag_name //查看该tag_name的信息
9. git tag  aem_v1_0_relase  // 打tag
9. git push origin aem_v1_0_relase// 上传tag,用git push 命令无法上传tag，#将tagname标签提交到服务器
9. git tag -l //
9. git fetch --tags  //只更新tags
10. gitk //git图形化界面
11. git checkout tag_name // 根据tag 更新，可能会提示你当前处于一个“detached HEAD" 状态。 tag 相当于是一个快照，是不能更改它的代码的。
12. git checkout -b branch_name tag_name //如果要在 tag 代码的基础上做修改，你需要一个分支
13. 限制git commit 文件size，配置.git/hooks/pre-commit文件，hard-limit和soft-limi
14. git remote -v //查看该文件夹所连接的远程仓库
15. git difftool commit_id1 commit_id2 //  找到该文件后,重新commit_id,git difftool 对比
16. git diff <commit1> <commit2> 文件目录D  //同一个文件目录,不同commit_id 之间的差异
17. git diff <commit1> -- 文件目录D  //--表示工作区,-- 和文件名 之间有一个 空格
18. git diff -- 文件名   //查看具体某个文件 在工作区和暂存区之间的差异,-- 和文件名 之间有一个 空格
19. git blame [filename]
20. git reset --soft HEAD^  //回退已commit 但未push的
21. git reset HEAD <fiel>   // 回退已经add,但是未commit的
22. git config -–global log.decorate auto //git log 显示tag
23. git checkout [<commit>]   //回退整个git仓库的文件，根据commit_id更新
24. git checkout [<commit>] [--] <filepath>   // [--] 表示 – 是可选参数，用于指定后面跟着的参数只是文件路径，而不是branch分支名或者commit信息。
~~~

### 3. git 上库(autostash)
~~~
1. git pull -r --autostash   //(git pull --rebase --autostash) autostash 选项自动隐藏并弹出未提交的更改
    //git stash
    //git  pull -r  //rebase
    //git stash popm
    //补充命令：git stash list
2. 解冲突
3. git add . // 解冲后，一般退到resbase状态，需要重新add commit
4. git commit -m "modify"
5. git push  origin master   
6. 备注：原型git push <远程主机名> <本地分支名>:<远程分支名>，如果分支名称一致，可以以省略冒号，eg:it push <远程主机名> <本地分支名>
~~~

### 4. git撤销、还原、放弃本地文件修改
1. 未使用git add 缓存代码
2. 已使用git add 缓存代码，未使用git commit
   ~~~
   git reset HEAD filepathname
   git reset HEAD   //放弃所有文件修改 (相当于撤销 git add 命令所在的工作。)

   // 补充知识
   git reset --soft HEAD    //参数用于回退到某个版本
   git reset --hard HEAD    //--hard 参数撤销工作区中所有未提交的修改内容，将暂存区与工作区都回到上一次版本，并删除之前的所有信息提交：
   git reset HEAD^            # 回退所有内容到上一个版本  
   git reset HEAD^^            # 回退所有内容到上上一个版本  
   ~~~
3. 已经用 git commit 提交了代码
   ~~~
   git reset --hard HEAD^来回退到上一次commit的状态
   git reset --hard HEAD^
   git reset --hard commitid，或者回退到任意版本，使用git log命令查看git提交历史和commitid
   ~~~
   备注:使用本命令后，本地的修改并不会消失，而是回到了第一步1；未使用git add 缓存代码，继续使用git checkout -- filepathname，就可以放弃本地修改

4. 已经用 git commit 提交了代码
   ~~~ 
   git reset --hard HEAD^ 来回退到上一次commit的状态
   git reset --hard HEAD^
   git reset --hard commitid，或者回退到任意版本，使用git log命令查看git提交历史和commitid
   ~~~

### 5. 拉分支
1. 场景:本地已经创建了分支dev（以dev为例，下同），而远程没有
   ~~~
   git push -u origin dev   
   ~~~
   或
   ~~~
   git push --set-upstream-to origin dev
   ~~~
2. 场景:远程已经创建了分支dev,而本地没有
   在pull远程分支的同时，创建本地分支并与之进行关联
   ~~~
   git pull origin dev:dev-------两个dev分别表示远程分支名：本地分支名
   ~~~
3. 场景:远程已经创建了分支dev,而本地新建分支需要关联 远端分支
   ~~~
   git branch -u origin/分支名   其中origin/分支名 中分支名 为远程分支名      
   ~~~
   或者
   ~~~
   git branch --set-upstream-to origin/分支名  
   ~~~   

### 6. 多分支互不干扰方案
1. 方法1,拉2个分支,独立工作 (推荐)
   ~~~
   1. 本地已有分支dev，写了需求a，先commit，即将工作区的内容提交到版本库中，否则切换到其他分支时，就会覆盖当前工作区的代码。（这步很重要）
   2. 在本地创建dev_bug分支，从远程dev分支中check（git checkout -b dev_bug origin/dev）
   3. 在本地dev_bug上修改bug，并commit、push到远程dev上
   4. 在本地变换到dev，继续做需求a
   ~~~
2. 方法2,stash 暂存
   ~~~
   1. 本地已有分支dev，写了需求a，但是不要提交。
   2. 执行git stash命令，将工作区的内容“储存起来”
   3. 接着在dev分支上修改bug，并提交，push
   4. 执行git stash pop，恢复工作区原来的内容
   ~~~

### 8. git diff
#### 1. 查看工作区和暂存区之间文件的差异
~~~
git diff 命令，默认查看的就是 工作区 和 暂存区之间文件的差异
1.git diff : 查看工作区和暂存区之间所有的文件差异
2.git diff -- 文件名：查看具体某个文件 在工作区和暂存区之间的差异
3.git diff -- 文件名1 文件名2 文件名3：查看多个文件在工作区和暂存区之间的差异
~~~
#### 2. 查看工作区和版本库之间文件的差异
~~~
git diff HEAD : 查看工作区与最新版本库之间的所有的文件差异
git diff 具体某个版本 : 查看工作区与具体某个提交版本之间的所有的文件差异
git diff HEAD -- 文件名 ： 查看工作区与最新版本库之间的 指定文件名的文件差异
git diff HEAD -- 文件名1 文件名2 文件名3 ：查看工作区与最新版本库之间的 指定文件名的多个文件差异
git diff 具体某个版本 -- 文件名 ： 查看工作区与具体某个版本之间的 指定文件名的文件差异
git diff 具体某个版本 -- 文件名1 文件名2 文件名3 ：查看工作区与最具体某个版本之间的 指定文件名的多个文件差异
~~~
#### 3. 查看暂存区和版本库之间文件的差异
~~~
git diff --cached : 查看暂存区和 上一次提交 的最新版本(HEAD)之间的所有文件差异
git diff --cached 版本号 ： 查看暂存区和 指定版本 之间的所有文件差异
git diff --cached -- 文件名1 文件名2 文件名3 ： 查看暂存区和 HEAD 之间的指定文件差异
git diff --cached 版本号 -- 文件名1 文件名2 文件名3 ： 查看暂存区和 指定版本 之间的指定文件差异
~~~
#### 4. 查看不同版本库之间文件的差异
~~~
git diff 版本号1 版本号2 ： 查看两个版本之间的差异
git diff 版本号1 版本号2 -- 文件名1 文件名2 ： 查看两个版本之间的指定文件之间的差异
git diff 版本号1 版本号2 --stat : 查看两个版本之间的改动的文件列表
git diff 版本号1 版本号2 src : 查看两个版本之间的文件夹 src 的差异
~~~

### 9. 个人案例
#### 案例 1:
   1. 问题：pull 后提示本地AEM分支比origin aem分支新，本地有3次commit，所以pull后到rebase状态
   2. 解决方法：
      ~~~
      git rebase --abort
      git status // 提示本地分支比远端分支 新
      git reset --soft HEAD^
      git status //提示本地分支和远端分支 一致了
      git commit -m "add xx"
      git push //更新至远端
      ~~~


### 10. 传送门
1. [git操作本地和远程仓库 新建分支 切换分支 合并分支 解决冲突](https://link.zhihu.com/?target=https%3A//javaweixin6.blog.csdn.net/article/details/105884936%3Fspm%3D1001.2101.3001.6650.6%26utm_medium%3Ddistribute.pc_relevant.none-task-blog-2%257Edefault%257EBlogCommendFromBaidu%257ERate-6-105884936-blog-75213159.pc_relevant_3mothn_strategy_and_data_recovery%26depth_1-utm_source%3Ddistribute.pc_relevant.none-task-blog-2%257Edefault%257EBlogCommendFromBaidu%257ERate-6-105884936-blog-75213159.pc_relevant_3mothn_strategy_and_data_recovery%26utm_relevant_index%3D7)
2. [腾讯技术工程：这才是真正的Git——Git内部原理揭秘！](https://zhuanlan.zhihu.com/p/96631135)
3. [git reset 命令 | 菜鸟教程](https://link.zhihu.com/?target=https%3A//www.runoob.com/git/git-reset.html)
4. [git本地创建多个分支互不干扰](https://www.cnblogs.com/BonnieWss/p/10711835.html)
5. [git撤销、还原、放弃本地文件修改](https://link.zhihu.com/?target=https%3A//blog.csdn.net/qq_27674439/article/details/121124869)
6. [Git基础-git diff 比较文件的差异](https://blog.csdn.net/qq_39505245/article/details/119899171)
7. [git log详细使用参数，查看某个文件修改具体内容,decorate](https://blog.csdn.net/helloxiaozhe/article/details/80563427)
8. [git 显示中文和解决中文乱码](https://zhuanlan.zhihu.com/p/133706032)