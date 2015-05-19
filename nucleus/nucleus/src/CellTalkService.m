/*
 ------------------------------------------------------------------------------
 This source file is part of Cell Cloud.
 
 Copyright (c) 2009-2014 Cell Cloud Team - www.cellcloud.net
 
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

#import "CellTalkService.h"
#import "CellSpeaker.h"
#import "CellPrimitive.h"
#import "CellDialect.h"
#import "CellDialectEnumerator.h"
#import "CellActionDialectFactory.h"
#import "CellTalkCapacity.h"
#import "CellInetAddress.h"
#import "CellLogger.h"

// Private
@interface CCTalkService ()
{
@private
    NSTimer *_daemonTimer;
    NSTimeInterval _tickTime;
    NSObject *_monitor;

    NSMutableArray *_speakers;          /// Speaker 列表
//    NSMutableDictionary *_speakerMap;   /// Speaker 映射关系
    NSMutableArray *_lostSpeakers;
    NSUInteger _hbCounts;               /// Speaker 心跳计数
}

// 守护定时器处理器。
- (void)handleDaemonTimer:(NSTimer *) timer;

@end


@implementation CCTalkService

/// 实例
static CCTalkService *sharedInstance = nil;

//------------------------------------------------------------------------------
+ (CCTalkService *)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCTalkService alloc] init];
    });
    return sharedInstance;
}
//------------------------------------------------------------------------------
- (id)init
{
    if ((self = [super init]))
    {
        _monitor = [[NSObject alloc] init];
        _speakers = [NSMutableArray array];
//        _speakerMap = [NSMutableDictionary dictionary];
        _hbCounts = 0;

        // 添加默认方言工厂
        [[CCDialectEnumerator sharedSingleton] addFactory:[[CCActionDialectFactory alloc] init]];
    }

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [_speakers removeAllObjects];
//    [_speakerMap removeAllObjects];
}

#pragma mark - Service Protocol

//------------------------------------------------------------------------------
- (BOOL)startup
{
    [self startDaemon];

    return TRUE;
}
//------------------------------------------------------------------------------
- (void)shutdown
{
    [self stopDaemon];
}

#pragma mark - Common Methods

//------------------------------------------------------------------------------
- (void)startDaemon
{
    if (nil != _daemonTimer)
    {
        [_daemonTimer invalidate];
        _daemonTimer = nil;
    }

    _daemonTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                    target:self
                                                    selector:@selector(handleDaemonTimer:)
                                                    userInfo:nil
                                                    repeats:TRUE];
}
//------------------------------------------------------------------------------
- (void)stopDaemon
{
    if (nil != _daemonTimer)
    {
        [_daemonTimer invalidate];
        _daemonTimer = nil;
    }
}
//------------------------------------------------------------------------------
- (void)handleDaemonTimer:(NSTimer *)timer
{
    NSDate *date = [NSDate date];
    _tickTime = date.timeIntervalSince1970;

    ++_hbCounts;
    if (_hbCounts >= 12)
    {
        // 120 秒一次心跳，计数器周期是 10 秒
        if (_speakers.count > 0)
        {
            for (CCSpeaker *spr in _speakers)
            {
                [spr heartbeat];
            }
        }

        _hbCounts = 0;
    }

    @synchronized (_monitor) {
        // 检查丢失连接的 Speaker
        if (nil != _lostSpeakers && [_lostSpeakers count] > 0)
        {
            NSMutableArray *discardedItems = [[NSMutableArray alloc] initWithCapacity:1];

            for (CCSpeaker *spr in _lostSpeakers)
            {
                if (nil != spr.capacity && _tickTime - spr.timestamp >= spr.capacity.retryInterval)
                {
                    [CCLogger d:@"Retry call cellet at %@:%d"
                        , spr.address.host
                        , spr.address.port];

                    [discardedItems addObject:spr];

                    [spr recall];
                }
            }

            [_lostSpeakers removeObjectsInArray:discardedItems];
        }
    }

    date = nil;
}

#pragma mark - Client Interfaces

//------------------------------------------------------------------------------
- (BOOL)call:(NSArray *)identifiers hostAddress:(CCInetAddress *)address
{
    return [self call:identifiers hostAddress:address capacity:nil];
}
//------------------------------------------------------------------------------
- (BOOL)call:(NSArray *)identifiers hostAddress:(CCInetAddress *)address capacity:(CCTalkCapacity *)capacity
{
    for (CCSpeaker *speaker in _speakers)
    {
        for (NSString *identifier in identifiers)
        {
            if ([speaker.identifiers containsObject:identifier])
            {
                // 列表里已经有对应的 Cellet，不允许再次 Call
                return FALSE;
            }
        }
    }

    CCSpeaker *speaker = [[CCSpeaker alloc] initWithCapacity:address capacity:capacity];
    [_speakers addObject:speaker];

//    for (NSString *identifier in identifiers)
//    {
//        [_speakerMap setValue:speaker forKey:identifier];
//    }

    /* FIXME 1/6/15 Ambrose
    @synchronized (_monitor) {
        if (nil != _lostSpeakers && [_lostSpeakers count] > 0)
        {
            if ([_lostSpeakers containsObject:current])
            {
                [_lostSpeakers removeObject:current];
            }
        }
    }
    */

    BOOL ret = [speaker call:identifiers];
    return ret;
}
//------------------------------------------------------------------------------
- (void)hangUp:(NSString *)identifier
{
    CCSpeaker *current = nil;
    for (CCSpeaker *speaker in _speakers)
    {
        if ([speaker.identifiers containsObject:identifier])
        {
            current = speaker;
            break;
        }
    }

    @synchronized(_monitor) {
        if (nil != _lostSpeakers && [_lostSpeakers count] > 0)
        {
            for (CCSpeaker *speaker in _lostSpeakers)
            {
                if ([speaker.identifiers containsObject:identifier])
                {
                    [_lostSpeakers removeObject:speaker];
                    break;
                }
            }
        }
    }

    if (nil != current)
    {
        [current hangUp];
        [_speakers removeObject:current];
//        [_speakerMap removeObjectForKey:identifier];
    }
}
//------------------------------------------------------------------------------
- (void)suspend:(NSString *)identifier duration:(NSTimeInterval)duration
{
    @synchronized(_monitor) {
        for (CCSpeaker *speaker in _speakers)
        {
            if ([speaker.identifiers containsObject:identifier])
            {
                [speaker suspend:duration];
                break;
            }
        }
    }
}
//------------------------------------------------------------------------------
- (void)resume:(NSString *)identifier startTime:(NSTimeInterval)startTime
{
    @synchronized(_monitor) {
        for (CCSpeaker *speaker in _speakers)
        {
            if ([speaker.identifiers containsObject:identifier])
            {
                [speaker resume:startTime];
                break;
            }
        }
    }
}
//------------------------------------------------------------------------------
- (BOOL)talk:(NSString *)identifier primitive:(CCPrimitive *)primitive
{
    CCSpeaker *speaker = nil;
    for (CCSpeaker *s in _speakers)
    {
        if ([s.identifiers containsObject:identifier])
        {
            speaker = s;
            break;
        }
    }

    if (nil == speaker)
    {
        return FALSE;
    }

    // 发送原语
    return [speaker speak:identifier primitive:primitive];
}
//------------------------------------------------------------------------------
- (BOOL)talk:(NSString *)identifier dialect:(CCDialect *)dialect
{
    CCPrimitive *primitive = [dialect translate];
    return [self talk:identifier primitive:primitive];
}
//------------------------------------------------------------------------------
- (BOOL)isCalled:(NSString *)identifier
{
    CCSpeaker *speaker = nil;
    @synchronized(_monitor) {
        for (CCSpeaker *s in _speakers)
        {
            if ([s.identifiers containsObject:identifier])
            {
                speaker = s;
                break;
            }
        }
    }

    if (nil == speaker)
    {
        return FALSE;
    }

    return [speaker isCalled];
}
//------------------------------------------------------------------------------
- (BOOL)isSuspended:(NSString *)identifier
{
    CCSpeaker *speaker = nil;
    @synchronized(_monitor) {
        for (CCSpeaker *s in _speakers)
        {
            if ([s.identifiers containsObject:identifier])
            {
                speaker = s;
                break;
            }
        }
    }

    if (nil == speaker)
    {
        return FALSE;
    }

    return [speaker isSuspended];
}
//------------------------------------------------------------------------------
- (void)markLostSpeaker:(CCSpeaker *)speaker
{
    speaker.timestamp = _tickTime;

    @synchronized(_monitor) {
        if (nil != _lostSpeakers)
        {
            if (![_lostSpeakers containsObject:speaker])
            {
                [_lostSpeakers addObject:speaker];
            }
        }
        else
        {
            _lostSpeakers = [NSMutableArray array];
            [_lostSpeakers addObject:speaker];
        }
    }
}

#pragma mark - Server Interfaces

@end
