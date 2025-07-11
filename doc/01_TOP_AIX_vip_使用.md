### 1.基础知识
#### 1. 协议
1. Constrain between size and address :  SVT_AXI_MAX_DATA_WIDTH

2. out of order transfer
~~~
this.slave_cfg[0].num_outstanding_xact = 16;
this.slave_cfg[0].reordering_algorithm = svt_axi_port_configuration::RANDOM;
this.slave_cfg[0].read_data_reordering_depth = 8;
~~~

~~~
Enable function
this.master_cfg[0].num_outstanding_xact = 16;
this.slave_cfg[0].num_outstanding_xact = 16;

Functional coverage
virtual function void new_transaction_started (svt_axi_port_monitor axi_monitor, svt_axi_transaction item);
  super.new_transaction_started(axi_monitor, item);
  num_outstanding_xact++;
endfunction

virtual function void transaction_ended (svt_axi_port_monitor axi_monitor, svt_axi_transaction item);
  super.transaction_ended(axi_monitor, item);
  num_outstanding_xact--;
endfunction
~~~

#### 2. 延时
1. 时延分为2类，一类是traction间(数值，如addr_valid_delay)，一类是traction，控制burst(数组，如wvalid_delay[])，

2. master vip常用延时

~~~
// Master VIP
svt_axi_transaction::addr_valid_delay   //请给定你需要的awready/arready反压时间，注意提前要把default_awready/default_arready设为默认的1，否则这个delay表示不同的含义
									    //PREV_ADDR_VALID
									    //PREV_ADDR_HANDSHAKE
										
										//FIRST_WVALID_DATE_BEFORE_ADDR
										//FIRE_DATA_HANDSHAKE_DATE_BEFORE_ADDR
	//rand	reference_event_for_addr_valid_delay_enum  referenc_event_for_addr_valid_delay = PREV_ADDR_HANDSHAKE
		
svt_axi_transaction::wvalid_delay[]   //驱动wvalid和下一个wvalid之间的delay，此处设置为0
svt_axi_transaction::rready_delay[]   //也和default_rready强相关，通过操作这部分可实现rready的反压
svt_axi_transaction::bready_delay     //驱动bready拉高完成握手后再拉低反压的时钟数，注意先把上面提到的default_bready设置为默认的1。
									  //如果default_bready改为0，则bready_delay表示拉高持续的时钟数。


~~~

3. slave vip常用延时
~~~
// Slave VIP
svt_axi_transaction::addr_ready_delay   //wr, 请给定你需要的awready/arready反压时间，注意提前要把default_awready/default_arready设为默认的1，否则这个delay表示不同的含义
									    //PREV_ADDR_VALID
									    //PREV_ADDR_HANDSHAKE
										
										//FIRST_WVALID_DATE_BEFORE_ADDR
										//FIRE_DATA_HANDSHAKE_DATE_BEFORE_ADDR
	//rand	reference_event_for_addr_valid_delay_enum  referenc_event_for_addr_valid_delay = PREV_ADDR_HANDSHAKE


svt_axi_transaction::wready_delay[]   //wr，请给定你需要的wready反压时间，注意提前要把default_wready设为默认的1，否则这个delay表示不同的含义
	//前提：svt_axi_port_configuration::toggle_ready_signal_during_idle_period is set
    //在WVALID=0时，wready 高还是低，
	//#wready_delay在WREADY 拉高后的才有效
	
svt_axi_transaction::rvalid_delay[]   //rd，请给定你需要的rvalid有效时间
	//rvalid_delay[0]   //reference_event_for_first_rvalid_delay
	//rvalid_delay[x]   //reference_event_for_next_rvalid_delay
	
svt_axi_transaction::bvalid_delay   //wr，请给定你需要的bvalid有效时间

									//LAST_DATA_HANDSHAKE
									//ADDR_HANDSHAKE
	//rand reference_event_for_bvlid_delay_enum reference_event_for_bvlid_delay = LAST_DATA_HANDSHAKE
~~~


4.  Delay slave read response
~~~
if(req_resp.xact_type == svt_axi_slave_transaction::WRITE) begin
  put_write_transaction_data_to_mem(req_resp);
end
else begin
  req_resp.suspend_response = 1; 
  fork begin 
	repeat(10)@(posedge test_top.clk);//wait for some delay
	get_read_data_from_mem_to_transaction(req_resp);
	req_resp.suspend_response = 0;
  end
  join_none
end
~~~

#### 4. 后门访问

5. Backdoor access on slave memory
~~~
axi_system_env.slave[0].axi_slave_mem.read(...);
axi_system_env.slave[0].axi_slave_mem.write(...);
axi_system_env.slave[0].axi_slave_mem.read_byte(...);
axi_system_env.slave[0].axi_slave_mem.write_byte(...);
axi_system_env.slave[0].axi_slave_mem.load_mem("mem_dump",,,0,32 );
~~~


#### 5. 覆盖率
1. Functional coverage
~~~
this.master_cfg[0].transaction_coverage_enable = 1
this.master_cfg[0].toggle_coverage_coverage_enable = 1
this.master_cfg[0].state_coverage_enable = 1

~~~

#### 5. 注错
1. Error inject
~~~
virtual function void pre_read_data_phase_started (svt_axi_slave axi_slave, svt_axi_transaction xact);
  
  foreach (xact.rresp[index]) begin
    xact.rresp[index] = svt_axi_slave_transaction::SLVERR;
  end
endfunction

~~~


2. Bus inactive error
~~~
int attribute
svt_axi_system_configuration::bus_inactivity_timeout = 256000

//Bus inactivity is defined as the time when all five channels of the AXI interface are idle. A timer is started if such a condition occurs. The timer is incremented by 1 every clock and is reset when there is activity on any of the five channels of the interface. If the number of clock cycles exceeds this value, an error is reported. If this value is set to 0, the timer is not started.

~~~

#### 6. 关日志
1. Turn off trans log
~~~
svt_axi_port_configuration::silent_mode = 0
~~~


#### 7. trace
1. Trace log
~~~
//applicable when the axi system monitor is enabled
svt_axi_system_configuration::display_summary_report=6; 
svt_axi_port_configuration::enable_tracing=1;
svt_axi_port_configuration::enable_reporting=1;
svt_axi_port_configuration::data_trace_enable=1;

Log:
env.axi_system_env.master_0.monitor.transaction_trace

~~~


### 2. 常用配置

#### 1. svt_axi_transaction
1. bvaild_delay
2. add_ready_delay
3. ZERO_DELAY_wt =100//于控制零延迟的权重
4. SHORT_DELAY_wt =500 //短延迟的权重
5. LONG_DELAY_
wt  =1 //长延迟分布的权重

#### 2. port_configuration 
1. axi_interface_type
2. data_width
3. addr_width
4. id_width
5. reset_type
6. 信号的coverage和protocol check使能等，
7. 其中num_outstanding_xact可定义主从机支持的outstanding深度

#### 3. 经验
0. commom_block, 如果例化了多组axi 接口，时钟不相同，不行配置接口的commom_block，
- 具体做法参考如下
~~~
axi_net_if.set_slave_commom_clock_mode(0,1) // 将通道1设置为0
~~~
- 内部实际的使用,实际是内部选择的，不一定是用的aclk
~~~
assign internal_aclk = (clock_enable == 0) ? 0 : ((common_clock_mode == 0) ?  aclk, common_aclk)
~~~
1. axi_interface_category: vt axi port configuration里面有个axi_interface_category变量，其取值有AXI_WRITE_ONLY、AXI_READ_ONLY、AXI_READ_WRITE三种。在DUT AXI总线只有读或者只有写时使用，可以减少对应其它通道的VIP连线。
2. write only/read only, 在confg 文件内关闭相关功能
- wr_only
~~~
this.slave_cfg[4].axi_interface_category = svt_axi_port_configuration::AIX_WRITE_ONLY;
this.slave_cfg[4].arid_enable     = 0;
this.slave_cfg[4].arilen_enable   = 0;
this.slave_cfg[4].arsize_enable   = 0;
this.slave_cfg[4].arburst_enable  = 0;
this.slave_cfg[4].arlock_enable   = 0;
this.slave_cfg[4].arcache_enable  = 0;
this.slave_cfg[4].arsize_enable   = 0;
this.slave_cfg[4].arlast_enable   = 0;
this.slave_cfg[4].arprot_enable   = 0;

this.slave_cfg[4].rresp_enable    = 0;
~~~
3. readonly
~~~
this.slave_cfg[4].axi_interface_category = svt_axi_port_configuration::AIX_READ_ONLY;
this.slave_cfg[4].awregion_enable = 0;
this.slave_cfg[4].awid_enable     = 0;
this.slave_cfg[4].awlen_enable    = 0;
this.slave_cfg[4].awsize_enable   = 0;
this.slave_cfg[4].awburst_enable  = 0;
this.slave_cfg[4].awlock_enable   = 0;
this.slave_cfg[4].awcache_enable  = 0;
this.slave_cfg[4].awprot_enable   = 0;
this.slave_cfg[4].awqos_enable    = 0;
this.slave_cfg[4].awuser_enable   = 0;

this.slave_cfg[4].wstrb_enable    = 0;
this.slave_cfg[4].wlast_enable    = 0;
this.slave_cfg[4].bid_enable      = 0;
this.slave_cfg[4].bresp_enable    = 0;
~~~

4. axi  slave mem的后面读写方法
- mem的方法 read /write, 注意参数不一样，read 的read_data是返回值，write方法的都是入参
- agent的方法read_byte，write_byte,
- 注意，base_test 或env 声明，例化，通过config_db 给对应的vip
	1.  confg_db set前2个参数是拼接地址，在env和base_test内使用路径不同
     2.  经验，同一个aix slave vip 只config_db设置1次，切勿多次设置，否则出错，rd的数据完全0，切记切记！


### 4. 传送门
1. [Synopsys验证VIP学习笔记（3）总线事务的配置和约束](https://blog.csdn.net/yumimicky/article/details/120531658?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-120531658-blog-123188346.235%5Ev38%5Epc_relevant_yljh&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-120531658-blog-123188346.235%5Ev38%5Epc_relevant_yljh&utm_relevant_index=1)
2. [01_TOP_snps_vip_入门](https://gitcode.com/bulaqi/IC/blob/main/doc/01_TOP_snps_vip_%E5%85%A5%E9%97%A8.md)
3. [01_TOP_snps_VIP_进阶](https://gitcode.com/bulaqi/IC/blob/main/doc/01_TOP_snps_VIP_%E8%BF%9B%E9%98%B6.md?init=initTree)
4. [01_TOP_vip文档使用说明.md](https://gitcode.com/bulaqi/IC/blob/main/doc/01_TOP_vip%E6%96%87%E6%A1%A3%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E.md)