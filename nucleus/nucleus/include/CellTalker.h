/*
 ------------------------------------------------------------------------------
 This source file is part of Cell Cloud.
 
 Copyright (c) 2009-2013 Cell Cloud Team - www.cellcloud.net
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ------------------------------------------------------------------------------
 */

#include "CellPrerequisites.h"

typedef enum _CCTalkerResult
{
    // 正确处理完成请求
    OK,

    // 连接失败
    CONNECT_FAILED,

    // 连接超时
    CONNECT_TIMEOUT,
    
    // 没有正确设置标示
    NO_IDENTIFIER,
    
    // 没有正确设置服务器地址
    NO_ADDRESS,
    
    // 未知错误
    UNKNOWN

} CCTalkerResult;

@interface CCTalker : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) CCInetAddress* address;
@property (nonatomic, assign) NSTimeInterval timeout;

/** 使用 Cellet Identifer 初始化。
 */
- (id)initWithIdentifier:(NSString *)identifier address:(CCInetAddress *)address;

/** 发送原语数据。
 */
- (CCTalkerResult)talkWithPrimitive:(CCPrimitive *)primitive;
//- (BOOL)talkWithPrimitive:(CCPrimitive *)primitive completed:(void(^)(CCTalker *))completed;

/** 发送方言数据。
 */
- (CCTalkerResult)talkWithDialect:(CCDialect *)dialect;

@end
