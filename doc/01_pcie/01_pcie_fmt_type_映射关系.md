### 1. Table 2-3 Fmt[2:0] and Type[4:0] Field Encodings
| **Fmt (3位)** | **Type (5位)** | **Description**               |
|---------------|----------------|------------------------------|
| 000           | 00000          | Memory Read Request (MRd)    |
| 000           | 00001          | Memory Read Request-Locked (MRdLk) |
| 001           | 00000          | Memory Write Request (MWr)   |
| 001           | 00001          | I/O Read Request (IORd)      |
| 001           | 00010          | I/O Write Request (IOWr)     |
| 001           | 00011          | Configuration Read Type 0 (CfgRd0) |
| 001           | 00100          | Configuration Write Type 0 (CfgWr0) |
| 001           | 00101          | Configuration Read Type 1 (CfgRd1) |
| 001           | 00101          | Configuration Write Type 1 (CfgWr1) |
| 001           | 11011          | Deprecated TLP Type (TCfgRd) |
| 001           | 11011          | Deprecated TLP Type (TCfgWr) |
| 001           | 10r2r1r0       | Message Request (Msg)        |
| 001           | 10r2r1r0       | Message Request with data payload (MsgD) |
| 000           | 01010          | Completion without Data (Cpl) |
| 001           | 01010          | Completion with Data (CplD)  |
| 000           | 01011          | Completion for Locked Memory Read without Data (CplLk) |
| 001           | 01011          | Completion for Locked Memory Read with Data (CplDLk) |
| 001           | 01100          | Fetch and Add AtomicOp Request (FetchAdd) |
| 001           | 01101          | Swap AtomicOp Request (Swap) |
| 001           | 01110          | Compare and Swap AtomicOp Request (CAS) |
| 001           | 01111          | Local TLP Prefix (LPrfx)     |
| 001           | 10000          | End-End TLP Prefix (EPrfx)   |


### 2. Table 2-17  msg_routing
| **r[2:0](3位)** | **Description**                     |
|-----------------|-------------------------------------|
| 000             | Routed to Root Complex              |
| 001             | Routed by Address 16 Address        |
| 010             | Routed by ID See Section 2.2.4.2    |
| 011             | Broadcast from Root Complex         |
| 100             | Local-Terminate at Receiver         |
| 101             | Gathered and routed to Root Complex |
| 110             | Reserved-Terminate at Receiver      |
| 111             | Reserved-Terminate at Receiver      |