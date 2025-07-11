[TOC]
### 1. 基础
#### 1. unique约束效果概述
   1. 在变量之间生成唯一的值
   2. 在数组中生成唯一元素(固定大小数组、动态数组、关联数组和队列)
   
#### 2. 唯一约束的例子
##### 1. 产生唯一的元素
1.eg
~~~
class unique_elements;
  rand bit [3:0] var_1,var_2,var_3;
  rand bit [7:0] array[6];
  constraint varis_c {unique {var_1,var_2,var_3};}
  constraint array_c {unique {array};}
  
  function void display();
    $display("var_1 = %p",var_1);
    $display("var_2 = %p",var_2);
    $display("var_3 = %p",var_3);
    $display("array = %p",array);
  endfunction
endclass
 
program unique_elements_randomization;
  unique_elements pkt;
 
  initial begin
    pkt = new();
    pkt.randomize();
    pkt.display();   
  end
endprogram
~~~
2. rsl
~~~
var_1 =  8 
var_2 = 14
var_3 = 11
array = '{'h81, 'h7b, 'h4, 'h47, 'he1, 'h17}
~~~

##### 2. 元素的唯一数组示例
1. eg
~~~
lass unique_elements;
  rand bit [31:0] array[10];
  
  constraint array_c {
    unique {array};
    foreach(array[i]) {
      array[i] < 10;
    }
  }
 
  function void display();
    $display("array = %p", array);
  endfunction
 
endclass
 
program unique_elements_randomization;
  unique_elements pkt;
 
  initial begin
    pkt = new();
    pkt.randomize();
    pkt.display();   
  end
  
endprogram
~~~

2. rsl
~~~
array = '{'h5, 'h7, 'h8, 'h1, 'h6, 'h9, 'h2, 'h3, 'h4, 'h0}
~~~



#### 3. unique if应用实例一
1. 概述
~~~
   In the below example,More than one condition is true.value of a=10, b=20 and c=40. conditions a<b and a<c are true, Therefore on execution, simulator issue a run time warning.“RT Warning: More than one condition match in ‘unique if’ statement.”
~~~
2. eg
~~~
module unique_if;
  //variables declaration
  int a,b,c;
 
   initial begin
     //initialization
     a=10;
     b=20;
     c=40;
 
     unique if ( a < b ) $display("\t a is less than b");
     else   if ( a < c ) $display("\t a is less than c");
     else                $display("\t a is greater than b and c");
  end
endmodule
~~~
3. rsl
~~~
a is less than b
RT Warning: More than one conditions match in 'unique if' statement.
~~~



#### 4. 三、unique if应用实例二
1. In below example,No condition is true and final if doesn’t have corresponding else.value of a=50, b=20 and c=40, conditions a<b and a<c are false,Therefore on execution, simulator issue a run time warning.“RT Warning: No condition matches in ‘unique if’ statement.”
2. eg
~~~
module unique_if;
  //variables declaration
  int a,b,c;
 
   initial begin
     //initialization
     a=50;
     b=20;
     c=40;
    
     unique if ( a < b ) $display("\t a is less than b");
     else   if ( a < c ) $display("\t a is less than c");
  end
     
endmodule
~~~
3. rsl
~~~
RT Warning: No condition matches in 'unique if' statement
~~~


#### 5. unique if应用实例二
1. In below example, value of a=50, b=20 and c=40.conditions a<b and a<c are false, so else part is true, there is no simulator run time warning.
2. eg
~~~
module unique_if;
 
  //variables declaration
  int a,b,c;
 
   initial begin
     //initialization
     a=50;
     b=20;
     c=40;
    
     priority if ( a < b ) $display("\t a is less than b");
     else     if ( a < c ) $display("\t a is less than c");
     else                  $display("\t a is greater than b and c");
  end
    
endmodule
~~~
3. rsl
~~~
a is greater than b and c
~~~



### 2. 经验总结
1. 随时产生unique的数组, std::randome 和 unique结合，
~~~
...
int entry_array[10];
std::randomize(entry_array) with{
    unique {entry_array}；
};
...
~~~


### 3. 传送门
  1. [SystemVerilog unique array and unique if](https://blog.csdn.net/gsjthxy/article/details/105126165)