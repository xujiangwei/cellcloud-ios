/*
 ------------------------------------------------------------------------------
 This source file is part of Cell Cloud.
 
 Copyright (c) 2009-2012 Cell Cloud Team - cellcloudproject@gmail.com
 
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

#import "CellStuff.h"

@implementation CCStuff

@synthesize type;
@synthesize literalBase;

//------------------------------------------------------------------------------
- (id)initWithString:(NSString *)value
{
    if ((self = [super init]))
    {
        _value = value;
        self.literalBase = CCLiteralBaseString;
        [self willInitType];
    }
    
    return self;
}
//------------------------------------------------------------------------------
- (id)initWithInt:(int)value
{
    if ((self = [super init]))
    {
        _value = [[NSString alloc] initWithFormat:@"%d", value];
        self.literalBase = CCLiteralBaseInt;
        [self willInitType];
    }

    return self;
}
//------------------------------------------------------------------------------
- (id)initWithLong:(long)value
{
    if ((self = [super init]))
    {
        _value = [[NSString alloc] initWithFormat:@"%ld", value];
        self.literalBase = CCLiteralBaseLong;
        [self willInitType];
    }
    
    return self;
}
//------------------------------------------------------------------------------
- (id)initWithBool:(BOOL)value
{
    if ((self = [super init]))
    {
        _value = [[NSString alloc] initWithFormat:@"%@", value ? @"true" : @"false"];
        self.literalBase = CCLiteralBaseBool;
        [self willInitType];
    }

    return self;
}
//------------------------------------------------------------------------------
- (id)initWithData:(NSData *)data literal:(CCLiteralBase)literal
{
    if ((self = [super init]))
    {
        _value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.literalBase = literal;
        [self willInitType];
    }
    
    return self;
}
//------------------------------------------------------------------------------
- (void)willInitType
{
    // Nothing
}
//------------------------------------------------------------------------------
- (NSString *)getValueAsString
{
    return _value;
}
//------------------------------------------------------------------------------
- (int)getValueAsInt
{
    return [_value intValue];
}
//------------------------------------------------------------------------------
- (long)getValueAsLong
{
    return [_value longLongValue];
}
//------------------------------------------------------------------------------
- (BOOL)getValueAsBoolean
{
    return [_value isEqualToString:@"true"] ? TRUE : FALSE;
}

@end
