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

#import "CellTalker.h"
#import "CellTalkService.h"

@interface CCTalker ()
{
    
}

@end

@implementation CCTalker

//------------------------------------------------------------------------------
- (id)initWithIdentifier:(NSString *)identifier address:(CCInetAddress *)address
{
    if ((self = [super init]))
    {
        self.identifier = identifier;
        self.address = address;

        self.timeout = 10;
    }

    return self;
}
//------------------------------------------------------------------------------
- (CCTalkerResult)talkWithPrimitive:(CCPrimitive *)primitive
{
    CCTalkerResult result = UNKNOWN;

    if ([[CCTalkService sharedSingleton] isCalled:self.identifier])
    {
        [[CCTalkService sharedSingleton] talk:self.identifier primitive:primitive];
        result = OK;
    }
    else
    {
        dispatch_queue_t talkingQueue = dispatch_queue_create("CCTalkingQueue", NULL);
        dispatch_group_t group = dispatch_group_create();

        __block CCTalkerResult ret = UNKNOWN;
        dispatch_group_async(group, talkingQueue, ^{
            [[CCTalkService sharedSingleton] call:self.identifier hostAddress:self.address];

            NSDate *start = [NSDate date];
            while (FALSE == [[CCTalkService sharedSingleton] isCalled:self.identifier])
            {
                [NSThread sleepForTimeInterval:0.2];
                
                NSDate *current = [NSDate date];
                if (current.timeIntervalSince1970 - start.timeIntervalSince1970 >= self.timeout)
                {
                    // 超时
                    ret = CONNECT_TIMEOUT;
                    break;
                }
            }
            start = nil;
        });
        
        // 阻塞等待
//        dispatch_time_t timeout = self.timeout * 1000000000l;
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        if ([[CCTalkService sharedSingleton] isCalled:self.identifier])
        {
            [[CCTalkService sharedSingleton] talk:self.identifier primitive:primitive];
            result = OK;
        }
        else
        {
            if (CONNECT_TIMEOUT == ret)
            {
                result = CONNECT_TIMEOUT;
            }
            else
            {
                result = CONNECT_FAILED;
            }
        }
        
        dispatch_release(talkingQueue);
        dispatch_release(group);
    }

    return result;
}
//------------------------------------------------------------------------------
- (CCTalkerResult)talkWithDialect:(CCDialect *)dialect
{
    return UNKNOWN;
}
//------------------------------------------------------------------------------


@end
