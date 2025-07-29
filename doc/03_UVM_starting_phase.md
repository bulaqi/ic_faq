### 1. 基础知识
#### 1. 效果：
    - 在seq中利用starting_phase属性句柄，实现raise_objection/drop_objection，
    - 避免用例中，忘记写raise/drop方法
2. 详解
在uvm_sequence这个基类中,有一个变量名为starting_phase,它的类型是uvm_phase,sequencer在启动default_sequence时,会自动做如下相关操作：
~~~
task my_sequencer::main_phase(uvm_phase phase);
    …
    seq.starting_phase = phase;
    seq.start(this);
    …
endtask
~~~
因此,可以在sequence中使用starting_phase进行提起和撤销objection(因为seq可以通过starting_phase调用raise/drop方法，原先是phase.raise/drop)

~~~
文件： src/ch2/section2.4/2.4.3/my_sequence.sv
class my_sequence extends uvm_sequence #(my_transaction);
    my_transaction m_trans;

    virtual task body();
        if(starting_phase != null) 
            starting_phase.raise_objection(this);
        repeat (10) begin
        `uvm_do(m_trans)
        end
        #1000;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask

    `uvm_object_utils(my_sequence)
endclass
~~~
从而,objection完全与sequence关联在了一起,在其他任何地方都不必再设置objection

### 2. 经验总结
1. uvm1.1中采用default_sequence中会自动给starting_phase进行赋值；
2. uvm1.2不建议使用default_sequence，这样不会给starting_phase。
    - 所以在uvm1.2中，即使使用了default_sequence，sequence中starting_phase仍然为null。
    - 建议采用start手动启动sequence，手动给starting_phase赋值，既然保证UVM版本的兼容性，也能增加代码的灵活性。


### 3. 传送门
1. [UVM中 sequence中的starting_phase](https://blog.csdn.net/weixin_42294124/article/details/125823159?spm=1001.2014.3001.5506)
