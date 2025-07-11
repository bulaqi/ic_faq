#!/bin/bash

# 检查参数数量
if [ $# -ne 1 ]; then
    echo "Usage: $0 <8-bit_hex_value>"
    echo "  Input: 8-bit hex value (e.g., 20, 0x46, 1A)"
    echo "  Format: [7:5] = fmt (3-bit), [4:0] = type (5-bit)"
    exit 1
fi

input=$1

# 去除可能的0x前缀
if [[ "${input}" == 0x* ]]; then
    input=${input#0x}
fi

# 验证输入是否为有效的1字节十六进制值
if ! [[ "$input" =~ ^[0-9A-Fa-f]{1,2}$ ]]; then
    echo "Error: Input must be a 1-byte hex value (00-FF)"
    exit 1
fi

# 转换为十进制
dec_value=$((16#${input}))

# 提取fmt (高3位) 和 type (低5位)
fmt=$(( (dec_value >> 5) & 0x7 ))
type=$(( dec_value & 0x1F ))

# 主判断逻辑
case "${fmt},${type}" in
    # 内存请求
    0,0)  echo "MRd (Memory Read 32-bit)" ;;
    1,0)  echo "MRd (Memory Read 64-bit)" ;;
    2,0)  echo "MWr (Memory Write 32-bit with Data)" ;;
    3,0)  echo "MWr (Memory Write 64-bit with Data)" ;;
    
    # I/O请求
    0,2)  echo "IORd (I/O Read)" ;;
    2,2)  echo "IOWr (I/O Write)" ;;
    
    # 配置请求
    0,4)  echo "CfgRd0 (Configuration Read Type 0)" ;;
    0,5)  echo "CfgRd1 (Configuration Read Type 1)" ;;
    2,4)  echo "CfgWr0 (Configuration Write Type 0)" ;;
    2,5)  echo "CfgWr1 (Configuration Write Type 1)" ;;
    
    # 消息请求（包含路由方式）
    0,6)  echo "Msg (Message without Data) - Routing: Implicit (Broadcast from Root)" ;;
    1,6)  echo "Msg (Message without Data, 64-bit) - Routing: Implicit (Broadcast from Root)" ;;
    2,6)  echo "MsgD (Message with Data) - Routing: Implicit (Broadcast from Root)" ;;
    3,6)  echo "MsgD (Message with Data, 64-bit) - Routing: Implicit (Broadcast from Root)" ;;
    0,7)  echo "Msg (Message without Data) - Routing: By Address (Address Routed)" ;;
    2,7)  echo "MsgD (Message with Data) - Routing: By Address (Address Routed)" ;;
    
    # 完成包
    0,10) echo "Cpl (Completion without Data)" ;;
    2,10) echo "CplD (Completion with Data)" ;;
    0,11) echo "Cpl (Completion without Data - Locked)" ;;
    2,11) echo "CplD (Completion with Data - Locked)" ;;
    
    # 原子操作
    0,12) echo "FetchAdd" ;;
    2,12) echo "FetchAdd with Data" ;;
    0,13) echo "Swap" ;;
    2,13) echo "Swap with Data" ;;
    0,14) echo "CAS" ;;
    2,14) echo "CAS with Data" ;;
    
    # 其他特殊类型
    0,16) echo "LPrfx" ;;
    2,16) echo "LPrfx with Data" ;;
    0,17) echo "EPrfx" ;;
    2,17) echo "EPrfx with Data" ;;
    
    # 未知类型
    *)    echo "Unknown TLP Type (input=0x${input}, fmt=${fmt}, type=${type})" ;;
esac

# 调试信息（可选）
# echo "Debug: Input=0x${input}, Dec=${dec_value}, Fmt=${fmt}, Type=${type}" >&2