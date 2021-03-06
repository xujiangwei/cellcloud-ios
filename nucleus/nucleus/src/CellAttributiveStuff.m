/*
 ------------------------------------------------------------------------------
 This source file is part of Cell Cloud.
 
 Copyright (c) 2009-2017 Cell Cloud Team (www.cellcloud.net)
 
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

#import "CellAttributiveStuff.h"

@implementation CCAttributiveStuff

//------------------------------------------------------------------------------
- (void)willInitType
{
    self.type = CCStuffTypeAttributive;
}

//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithString:(NSString *)value
{
    return [[CCAttributiveStuff alloc] initWithString:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithInt:(int)value
{
    return [[CCAttributiveStuff alloc] initWithInt:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithUInt:(unsigned int)value
{
    return [[CCAttributiveStuff alloc] initWithUInt:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithLong:(long)value
{
    return [[CCAttributiveStuff alloc] initWithLong:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithULong:(unsigned long)value
{
    return [[CCAttributiveStuff alloc] initWithULong:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithLongLong:(long long)value
{
    return [[CCAttributiveStuff alloc] initWithLongLong:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithBool:(BOOL)value
{
    return [[CCAttributiveStuff alloc] initWithBool:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithDictionary:(NSDictionary *)value
{
    return [[CCAttributiveStuff alloc] initWithDictionary:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithArray:(NSArray *)value
{
    return [[CCAttributiveStuff alloc] initWithArray:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithFloat:(float)value
{
    return [[CCAttributiveStuff alloc] initWithFloat:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithDouble:(double)value
{
    return [[CCAttributiveStuff alloc] initWithDouble:value];
}
//------------------------------------------------------------------------------
+ (CCAttributiveStuff *)stuffWithData:(NSData *)value
{
    return [[CCAttributiveStuff alloc] initWithBin:value];
}

@end
