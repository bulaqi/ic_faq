#!/bin/bash

# PCIe Message Type Decoder (PCIe 5.0 compliant)
# 输入：16进制msg_code (00-1F)
# 输出：对应的PCIe Message类型

# 检查输入参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <hex_msg_code>"
    echo "Example: $0 10"
    echo "Example: $0 1F"
    exit 1
fi

# 验证输入格式
input=$(echo "$1" | tr '[:lower:]' '[:upper:]')
if ! [[ $input =~ ^[0-9A-F]{1,2}$ ]]; then
    echo "Error: Input must be 1 or 2 digit hex value (e.g., '10' or '1F')"
    exit 1
fi

# 转换为十进制 (确保处理单数字输入)
msg_code=$((16#$input))

# 确保在有效范围内 (0-31)
if [ $msg_code -lt 0 ] || [ $msg_code -gt 31 ]; then
    echo "Error: Message code must be between 0x00 and 0x1F"
    exit 1
fi

# 解码Message类型
case $msg_code in
    0x00|0) echo "Unlock Message" ;;
    0x01|1) echo "PME_TO_Ack Message" ;;
    0x02|2) echo "PM_Enter_L1 Message" ;;
    0x03|3) echo "PM_Enter_L23 Message" ;;
    0x04|4) echo "PM_Active_State_Request_L1 Message" ;;
    0x05|5) echo "Wake Message" ;;
    0x06|6) echo "PME_Turn_Off Message" ;;
    0x07|7) echo "PME_Status Message" ;;
    0x08|8) echo "Assert_INTx Message" ;;
    0x09|9) echo "Deassert_INTx Message" ;;
    0x0A|10) echo "Signal_Interrupt Message" ;;
    0x0B|11) echo "Locked_Transaction_Completion Message" ;;
    0x10|16) echo "Set_Slot_Power_Limit Message" ;;
    0x11|17) echo "Attention_Button_Pressed Message" ;;
    0x12|18) echo "Attention_Indicator_On Message" ;;
    0x13|19) echo "Attention_Indicator_Off Message" ;;
    0x14|20) echo "Attention_Indicator_Blink Message" ;;
    0x15|21) echo "Power_Indicator_On Message" ;;
    0x16|22) echo "Power_Indicator_Off Message" ;;
    0x17|23) echo "Power_Indicator_Blink Message" ;;
    0x18|24) echo "Hot-Plug_Surprise Message" ;;
    0x19|25) echo "Hot-Plug_Request Message" ;;
    0x1A|26) echo "Hot-Plug_Attention Message" ;;
    0x1B|27) echo "LED_On Message" ;;
    0x1C|28) echo "LED_Off Message" ;;
    0x1D|29) echo "LED_Blink Message" ;;
    0x1E|30) echo "Device_Power_Change_Request Message" ;;
    0x1F|31) echo "Device_Power_Change_Response Message" ;;
    *) echo "Reserved Message" ;;
esac