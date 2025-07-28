### 1. 基础
#### 1. 存储器读请求 TLP 中没有 Data Payload 字段,此时使用Length 字段表示需要读取多少数据。
1. 当该字段为 n 时,表示需要获取 n 个 DW,其中 0≤n≤0x3FF，
2. 当 n=0 时,表示数据长度为 1024DW,
3. 如果 PCIe 主设备传送的单位小于 1 个 DW 或者传送的数据不足以 DW 为界时需要使用“DE BE”字段
#### 2. DUT 的RCB的理解
1. RCB取值64B/128B,EP的RCB取值64B/128B
2. 所以dut是EP时，RCB其实可以选择为128B，因为RCB要求是第一个cpl是N倍的RCB对齐的，所以可以用128B覆盖rc为64B的的值

### 2. ACS
1. AT（Address Type）只对MEM报文和原子报文有效，IO报文该字段默认为0
