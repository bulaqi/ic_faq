### 1. 基础知识
1. ECRC 涵盖了随着 TLP 通过的路径而不变的所有字段（不变字段）。
- ECRC 由源组件中的事务层生成，并由最终 PCI Express 接收器以及可选的中间接收器进行检查（如果支持）。
- 支持 ECRC 检查的Switch 必须在针对 Switch 本身的 TLP 上检查 ECRC。这样的 Switch 可以选择检查它转发的 TLP 上的 ECRC。
- 在 Switch 转发的 TLP上，无论 Switch 是否检查 ECRC 或 ECRC 检查失败，Switch 都必须将 ECRC（未转发）保持为 TLP 的组成部分


2. 为什么有ECRC
当 TLP 经过 Switch 时，有些字段可能会被 Switch 修改，但有些影响 TLP 传输的字段不能修改。
在这种情况下，Switch 会重新生成 LCRC。（字段修改过程中，LCRC无法保护）
Switch 内部可能会发生数据损坏，为损坏的数据重新生成一个好的 LCRC 会掩盖错误的存在。
为了确保在要求高数据可靠性的系统中进行端到端数据完整性检测，可以在 TLP末尾的 TLP Digest 字段中放置事务层端到端 32 位 CRC（ECRC）


4. 因为 ECRC 不能维持变量字段的端到端完整性
~~~
1. Type 字段的 bit 0 是个变量。当配置请求从 Type 1 更改为 Type 0 时，Type 字段的 bit 0 会更改。
2. EP 字段是个变量。
3. 所有其他字段是不变量
~~~

5. 使用错误转发的情况
~~~
Example #1：读取主内存时遇到不可纠正的错误。
Example #2：PCI 写内存时遇到奇偶校验错误。
Example #3：内部数据缓存的数据完整性错误
~~~

6. 使用错误转发的适用
- 错误传递只是针对 TLP 中的 Data Payload 是否被破坏，和 TLP 包头的内容无关。也就是说错误传递只是针对那些带有 Data Payload 的 TLP 的，如 Memory、Configuration、I/O 写或者带有返回数据的Completion。
- PCIe Spec 没有定义对没有 Data Payload的 TLP，其 TLP 包头中的 EP 却为 1 的情况应当如何处理。
- 作用
    - 错误传递用于控制系统中错误的传播，以及进行系统诊断等。
    - 请注意，错误传递不会导致 Link Layer Retry——仅当数据链路层中的TLP 错误检测机制确定链路上存在传输错误时，才会重试中毒的 TLP

7. 特殊应用场景举例
- 便于发送端（Request）和系统分析错误
~~~
假设发送端（Request）向接收端（Completer）发送了读数据请求，接收端从某个内存设备中读取数据后通过 Completion 返回数据给发送端。但是在此过程中发生了错误，接收端（Completer）因此不向发送端（Request）返回 Completion，则发送端只会产生 Completion Timeout 错误，却难以分析错误原因。如果接收端返回Poisoned Completion TLP 给发送端（TLP 包头中 EP 为 1），则发送端至少可以确认接收端正确地接收到了其发出的请求（Request）。
~~~
- 便于发现 Switch（或其他桥设备）中的错误：假设 TLP 中的 Data Payload 是在 Switch 中被破坏的，采用错误传递的方式有助于发现该错误。
- 有些应用允许接收存在错误的数据：比如实时的音频或者视频传输，其宁可接收到有些许错误的数据，也需要尽量保证数据传输的实时性。
- 数据可能通过应用层恢复：有些应用可能采用了特殊的编码 ，该编码可以恢复某些被破坏的数据（如 ECC 可恢复 1 位的错误）。
- 需要注意的是，Poisoning 操作只能在事务层进行。原因很简单：数据链路层和物理层在任何情况下，都不会检查 TLP 包头的内容，更不会修改TLP 包头

8. 中毒的处理规则
- 在发送器中实现 TLP 中毒是可选实现的。
- 数据中毒只会应用于带数据的 Write Request(Posted or Non-Posted)、Message with Data、AtomicOp Request、Read Completion、或 AtomicOp Completion 中。
  - 中毒 TLP 的 EP 字段会设置为 1b。
  - 发送器仅可将包含数据有效载荷的 TLP 的 EP 位设置为 1b。
  - 如果不包括数据有效载荷的任何 TLP 设置了 EP 位，则未指定接收器的行为

- 如果发送器支持数据中毒，则发送器已知包含不良数据的 TLP 必须使用上面定义的中毒机制。

- 如果下游端口支持Poisoned TLP Egress Blocking，Poisoned TLP Egress Blocking Enable 字段置 1，并且中毒 TLP 的目的地需要从Egress Port流出，则除非更高的优先级，否则该端口必须将TLP作为一个 Poisoned TLP Egress Blocked error 处理。参见Section 6.2.3.2.3，Section 6.2.5 和 Section 7.9.15.2。进一步：
  - 该 Port 不能发送此 TLP。
  - 如果未触发DPC且TLP是 Non-Posted Request，则端口必须返回带有 Unsupported Request Completion Status的Completion。
  - 如果触发了 DPC，则端口必须按照 Section 2.9.3 中所述进行操作。

4. 下列带中毒数据的请求不能修改其中目标的值：
  - Configuration Write Request。
  - 下列以控制寄存器或control structure 为目标的 Completer：携带数据的I/O Write Request、Memory Write Request或
non-vendor-defined Message。
- AtomicOp Request。

- 除非存在更高的优先级错误，否则完成者必须将这些请求作为Poisoned TLP Received error 来处理，
- 并且如果请求是Non-Posted的，则完成者还必须返回完成状态为 Unsupported Request (UR)的 Completion（请参阅 Section 6.2.3.2.3、Section6.2.3.2.4 和 Section 6.2.5）。
- Switch必须按原先未中毒的路由方式路由请求，除非该请求的目标是 Switch本身，在这种情况下，Switch 是请求的完成者，并且必须遵循上述规则

对于某些应用程序，可能更需要 Completer 在写请求中使用不以控制寄存器或控制结构为目标的中毒数据-这种使用是禁止的。
同样，请求者可能希望使用在完成中标记为中毒的数据-这种使用方式也是禁止的


### 2. 经验总结

### 3. 传送门
