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

#import "CellLoggerManager.h"

@implementation CCLoggerManager

@synthesize delegate = _delegate;

/// 实例
static CCLoggerManager *sharedInstance = nil;

//------------------------------------------------------------------------------
+ (CCLoggerManager *)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCLoggerManager alloc] init];
    });
    return sharedInstance;
}
//------------------------------------------------------------------------------
- (id)init
{
    if ((self = [super init]))
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    _dateFormatter = nil;
}
//------------------------------------------------------------------------------
- (void)log:(NSString *)text level:(CCLogLevel)level
{
    switch (level)
    {
    case LL_DEBUG:
    {
        NSLog(@"[DEBUG] %@", text);

        if (nil != _delegate)
        {
            NSString *currentDateStr = [_dateFormatter stringFromDate:[NSDate date]];
            NSString *logstr = [[NSString alloc] initWithFormat:@"%@ [DEBUG] %@", currentDateStr, text];

            [_delegate logDebug:logstr];
        }

        break;
    }
    case LL_INFO:
    {
        NSLog(@"[INFO] %@", text);
        
        if (nil != _delegate)
        {
            NSString *currentDateStr = [_dateFormatter stringFromDate:[NSDate date]];
            NSString *logstr = [[NSString alloc] initWithFormat:@"%@ [INFO] %@", currentDateStr, text];
            
            [_delegate logInfo:logstr];
        }
        
        break;
    }
    case LL_WARN:
    {
        NSLog(@"[WARN] %@", text);
        
        if (nil != _delegate)
        {
            NSString *currentDateStr = [_dateFormatter stringFromDate:[NSDate date]];
            NSString *logstr = [[NSString alloc] initWithFormat:@"%@ [WARN] %@", currentDateStr, text];
            
            [_delegate logWarn:logstr];
        }

        break;
    }
    case LL_ERROR:
    {
        NSLog(@"[ERROR] %@", text);
        
        if (nil != _delegate)
        {
            NSString *currentDateStr = [_dateFormatter stringFromDate:[NSDate date]];
            NSString *logstr = [[NSString alloc] initWithFormat:@"%@ [ERROR] %@", currentDateStr, text];
            
            [_delegate logError:logstr];
        }

        break;
    }
    default:
        break;
    }
}
//------------------------------------------------------------------------------
- (void)log:(CCLogLevel)level textFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *text = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    [self log:text level:level];
}

@end
