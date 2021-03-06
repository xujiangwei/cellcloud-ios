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

#import "CellChunkDialect.h"
#import "CellChunkDialectFactory.h"
#import "CellDialectEnumerator.h"
#import "CellPredicateStuff.h"
#import "CellPrimitive.h"
#import "CellSubjectStuff.h"

@implementation CCChunkDialect

@synthesize delegate = _delegate;
@synthesize sign = _sign;
@synthesize chunkIndex = _chunkIndex;
@synthesize chunkNum = _chunkNum;
@synthesize data = _data;
@synthesize length = _length;
@synthesize totalLength = _totalLength;
@synthesize speedInKB = _speedInKB;

- (id)init
{
    if (self = [super initWithName:CHUNK_DIALECT_NAME tracker:@"none"])
    {
        _sign = nil;
        _chunkIndex = -1;
        
        _speedInKB = 20;

        self.infectant = NO;
        self.readIndex = 0;
    }

    return self;
}
//------------------------------------------------------------------------------
- (id)initWithTracker:(NSString *)tracker
{
    if (self = [super initWithName:CHUNK_DIALECT_NAME tracker:tracker])
    {
        _speedInKB = 20;
        
        self.infectant = NO;
        self.readIndex = 0;
    }

    return self;
}
//------------------------------------------------------------------------------
- (id)initWithSign:(NSString *)sign totalLength:(long)totalLength chunkIndex:(int)chunkIndex
          chunkNum:(int)chunkNum data:(NSData *)data length:(int)length
{
    if (self = [super initWithName:CHUNK_DIALECT_NAME tracker:@"none"])
    {
        _sign = sign;
        _totalLength = totalLength;
        _chunkIndex = chunkIndex;
        _chunkNum = chunkNum;
        _data = [NSData dataWithData:data];
        _length = length;
        
        _speedInKB = 20;

        self.infectant = NO;
        self.readIndex = 0;
    }
 
    return self;
}
//------------------------------------------------------------------------------
- (id)initWithTracker:(NSString *)tracker sign:(NSString *)sign totalLength:(long)totalLength
           chunkIndex:(int)chunkIndex chunkNum:(int)chunkNum data:(NSData *)data length:(int)length
{
    if (self = [super initWithName:CHUNK_DIALECT_NAME tracker:tracker])
    {
        _sign = sign;
        _totalLength = totalLength;
        _chunkIndex = chunkIndex;
        _chunkNum = chunkNum;
        _data = [NSData dataWithData:data];
        _length = length;
        
        _speedInKB = 20;

        self.infectant = NO;
        self.readIndex = 0;
    }

    return self;
}

//------------------------------------------------------------------------------
- (void)fireProgress:(NSString *)target
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(onProgress:andTraget:)])
    {
        [_delegate onProgress:self andTraget:target];
        if (_chunkIndex + 1 < _chunkNum)
        {
            _delegate = nil;
        }
    }
}
//------------------------------------------------------------------------------
- (void)fireCompleted:(NSString *)target
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(onCompleted:andTarget:)])
    {
        [_delegate onCompleted:self andTarget:target];
    }
}
//------------------------------------------------------------------------------
- (void)fireFailed:(NSString *)target
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(onFailed:andTarget:)])
    {
        [_delegate onFailed:self andTarget:target];
    }
}
//------------------------------------------------------------------------------
- (CCPrimitive *)reconstruct
{
    CCPrimitive *primitive = [super reconstruct];

    [primitive commit:[CCSubjectStuff stuffWithString:_sign]];
    [primitive commit:[CCSubjectStuff stuffWithInt:_chunkIndex]];
    [primitive commit:[CCSubjectStuff stuffWithInt:_chunkNum]];
    [primitive commit:[CCSubjectStuff stuffWithData:_data]];
    [primitive commit:[CCSubjectStuff stuffWithInt:_length]];
    [primitive commit:[CCSubjectStuff stuffWithLong:_totalLength]];

    return primitive;
}
//------------------------------------------------------------------------------
- (void)construct:(CCPrimitive *)primitive
{
    NSMutableArray *list = primitive.subjects;
    _sign = [(CCSubjectStuff *)[list objectAtIndex:0] getValueAsString];
    _chunkIndex = [(CCSubjectStuff *)[list objectAtIndex:1] getValueAsInt];
    _chunkNum = [(CCSubjectStuff *)[list objectAtIndex:2] getValueAsInt];
    _data = [(CCSubjectStuff *)[list objectAtIndex:3] getValue];
    _length = [(CCSubjectStuff *)[list objectAtIndex:4] getValueAsInt];
    _totalLength = [(CCSubjectStuff *)[list objectAtIndex:5] getValueAsLong];
}
//------------------------------------------------------------------------------
- (NSArray *)cancel
{
    CCChunkDialectFactory *factory =
        (CCChunkDialectFactory *)[[CCDialectEnumerator sharedSingleton] getFactory:CHUNK_DIALECT_NAME];
    return [factory cancel:_sign];
}
//------------------------------------------------------------------------------
- (BOOL)hasCompleted
{
    CCChunkDialectFactory *factory =
            (CCChunkDialectFactory *)[[CCDialectEnumerator sharedSingleton] getFactory:CHUNK_DIALECT_NAME];
    return [factory checkCompleted:_sign];
}
//------------------------------------------------------------------------------
- (BOOL)isLast
{
    return (_chunkIndex + 1 == _chunkNum);
}
//------------------------------------------------------------------------------
- (int)read:(int)index andData:(NSMutableData *)buffer
{
    CCChunkDialectFactory *factory =
            (CCChunkDialectFactory *)[[CCDialectEnumerator sharedSingleton] getFactory:CHUNK_DIALECT_NAME];
    return [factory read:_sign withIndex:index withData:buffer];
}
//------------------------------------------------------------------------------
- (int)read:(NSMutableData *)buffer
{
    if (_readIndex >= _chunkNum)
    {
        return -1;
    }
    
    CCChunkDialectFactory *factory =
            (CCChunkDialectFactory *)[[CCDialectEnumerator sharedSingleton] getFactory:CHUNK_DIALECT_NAME];
    int length = [factory read:_sign withIndex:_readIndex withData:buffer];
    ++_readIndex;
    return length;
}
//------------------------------------------------------------------------------
- (void)resetRead
{
    _readIndex = 0;
}
//------------------------------------------------------------------------------
- (void)clearAll
{
    CCChunkDialectFactory *factory =
            (CCChunkDialectFactory *)[[CCDialectEnumerator sharedSingleton] getFactory:CHUNK_DIALECT_NAME];
    [factory clear:_sign];
}

@end
