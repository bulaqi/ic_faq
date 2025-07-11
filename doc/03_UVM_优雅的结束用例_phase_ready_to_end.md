### 1. 基础

#### 1. scb控制平台的结束
1. 注意事项
- 问题1：无限等待风险 --改进方案：添加超时机制
- 问题2：多次触发     -- 改进方案：添加状态标志
- 问题3：缺少父类调用 -- 改进方案-添加super调用

2. eg
~~~
class scoreboard_with_phase_ready_to_end extends app_pipeline_tb::scoreboard;
    bit delay_in_progress = 0;
    int timeout_ns = 1000; // 默认1us超时
    
    virtual function void phase_ready_to_end(uvm_phase phase);
        super.phase_ready_to_end(phase); // 调用父类方法
        
        if (phase.get_name() != "run") 
            return;
        //if(phase.is(uvm_run_phase::get())) 
        //    return;

        if (item_stream.size() != 0 && !delay_in_progress) begin //delay_in_progress标记位
            delay_in_progress = 1;
            phase.raise_objection(this, "Delaying for pending items");  //raise
            
            fork
                begin
                    process_remaining_items(phase);
                    delay_in_progress = 0;
                end
            join_none
        end
    endfunction

    virtual task process_remaining_items(uvm_phase phase);
        fork
            // 主处理任务
            begin
                while (item_stream.size() > 0) begin
                    process_item(item_stream.pop_front());
                end
            end
            
            // 超时保护
            begin
                #timeout_ns;
                `uvm_error("TIMEOUT", $sformatf("%0d items not processed", 
                          item_stream.size()))
            end
        join_any
        disable fork;
        
        phase.drop_objection(this, "Pending items processed");  //别掉函数中drop,所以需要传参，phase
    endtask

    // 处理单个项的方法（需在具体记分板中实现）
    virtual task process_item(input item_type item);
        // 具体处理逻辑
    endtask

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    `uvm_component_utils(scoreboard_with_phase_ready_to_end)
endclass
~~~

### 2. 经验

### 3. 传送门
1. [如何优雅地结束UVM Test](https://zhuanlan.zhihu.com/p/592480267)