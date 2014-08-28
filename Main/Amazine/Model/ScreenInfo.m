//
//  ScreenInfo.m
//  ChatApplication
//
//  Created by veenus on 26/02/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import "ScreenInfo.h"

@implementation ScreenInfo
{
    
}
+(float)getScreenWidth
{
    float screenWidth=[[UIScreen mainScreen]bounds].size.width;
    return screenWidth;
}
+(float)getScreenHeight
{
    float screenHeight=[[UIScreen mainScreen]bounds].size.height;
    return screenHeight;
}

@end
