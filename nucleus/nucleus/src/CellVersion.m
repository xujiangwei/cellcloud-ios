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

#import "CellVersion.h"

#define CC_MAJOR 1

#define CC_MINOR 6

#define CC_REVISION 11

#define CC_NAME @"Xi"

#define CC_VERSION_NUMBER 160

@implementation CCVersion

//------------------------------------------------------------------------------
+ (int)major
{
    return CC_MAJOR;
}
//------------------------------------------------------------------------------
+ (int)minor
{
    return CC_MINOR;
}
//------------------------------------------------------------------------------
+ (int)revision
{
    return CC_REVISION;
}
//------------------------------------------------------------------------------
+ (NSString *)name
{
    return CC_NAME;
}
//------------------------------------------------------------------------------
+ (int)versionNumber
{
    return CC_VERSION_NUMBER;
}

@end
