//
//  NatTypeImpl.h
//  AVInterface
//
//  Created by chenjianjun on 13-11-6.
//  Copyright (c) 2013年 zc. All rights reserved.
//

#ifndef __AVInterface__NatTypeImpl__
#define __AVInterface__NatTypeImpl__

#include <iostream>
#include "APITypes.h"

class NatTypeImpl
{
public:
    NatTypeImpl(){}
    ~NatTypeImpl(){}
    
    NatType GetNatType(const char* peerName);
};

#endif /* defined(__AVInterface__NatTypeImpl__) */
