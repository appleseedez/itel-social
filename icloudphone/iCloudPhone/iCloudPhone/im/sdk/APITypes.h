//
//  APITypes.h
//  AVInterface
//
//  Created by chenjianjun on 13-7-9.
//  Copyright (c) 2013年 zc. All rights reserved.
//

#ifndef AVInterface_APITypes_h
#define AVInterface_APITypes_h

// 操作系统类型
enum OsType
{
    OsT_ANDRIOD = 1,
    OsT_IOS = 2
};

// 操作类型
enum OperatorType
{
    OpT_Speaker = 0,// 外放控制
    OpT_EC = 1,// 回音消除
    OpT_AGC = 2,// 自动增益
    OpT_NS = 3// 降噪
};

// 声音控制参数设置
typedef struct stVoEControlParameters
{
    OsType ostype;// 操作系统类型
    OperatorType optype;// 操作类型
    bool enable;// ture是开启 false是关闭
    int iVolume;// 操作类型是外放控制时，这个表示音量
}VoEControlParameters;

// Define enum with different types of NAT
typedef enum
{
    StunTypeUnknown=0,
    StunTypeFailure,
    StunTypeOpen,
    StunTypeBlocked,
    
    StunTypeIndependentFilter,
    StunTypeDependentFilter,
    StunTypePortDependedFilter,
    StunTypeDependentMapping,
    
    //StunTypeConeNat,
    //StunTypeRestrictedNat,
    //StunTypePortRestrictedNat,
    //StunTypeSymNat,
    
    StunTypeFirewall,
} NatType;

typedef struct stP2PPeerArgc
{
    // 入参
    unsigned int selfSsid;// 自己的ssid
    unsigned int otherSsid;// 对方的ssid
    int selfNATType;// 自己的NAT类型
    int otherNATType;// 对方的NAT类型
    char otherInterIP[16];// 对方的外网地址
    unsigned short otherInterPort;// 对方的外网端口
    char otherLocalIP[16];// 对方的内网地址
    unsigned short otherLocalPort;// 对方的内网端口
    char otherForwardIP[16];// 转发地址
    unsigned short otherForwardPort;// 转发端口
    bool localEnble;
    
    // 出参
    bool islocal;// 内网可用
    bool isInter;// 外网可用
    bool isforward;// 转发可用
    
    stP2PPeerArgc()
    {
    }
    
    void clear()
    {
        selfSsid = 0;
        otherSsid = 0;
        selfNATType = 0;
        otherNATType = 0;
        
        ::memset(otherInterIP, 0x00, sizeof(otherInterIP));
        otherInterPort = 0;
        ::memset(otherLocalIP, 0x00, sizeof(otherLocalIP));
        otherLocalPort = 0;
        ::memset(otherForwardIP, 0x00, sizeof(otherForwardIP));
        otherForwardPort = 0;
        
        islocal = false;
        isInter = false;
        isforward = false;
        localEnble = false;
    }
}TP2PPeerArgc;

typedef unsigned char uint8;
typedef unsigned int uint32;
typedef unsigned short uint16;  // NOLINT

inline void Set8(void* memory, size_t offset, uint8 v)
{
    static_cast<uint8*>(memory)[offset] = v;
}

inline uint8 Get8(const void* memory, size_t offset)
{
    return static_cast<const uint8*>(memory)[offset];
}

inline uint16 GetBE16(const void* memory) {
    return static_cast<uint16>((Get8(memory, 0) << 8) |
                               (Get8(memory, 1) << 0));
}

inline void SetBE16(void* memory, uint16 v) {
    Set8(memory, 0, static_cast<uint8>(v >> 8));
    Set8(memory, 1, static_cast<uint8>(v >> 0));
}

inline void SetBE32(void* memory, uint32 v) {
    Set8(memory, 0, static_cast<uint8>(v >> 24));
    Set8(memory, 1, static_cast<uint8>(v >> 16));
    Set8(memory, 2, static_cast<uint8>(v >> 8));
    Set8(memory, 3, static_cast<uint8>(v >> 0));
}

inline uint32 GetBE32(const void* memory) {
    return (static_cast<uint32>(Get8(memory, 0)) << 24) |
    (static_cast<uint32>(Get8(memory, 1)) << 16) |
    (static_cast<uint32>(Get8(memory, 2)) << 8) |
    (static_cast<uint32>(Get8(memory, 3)) << 0);
}

#endif
