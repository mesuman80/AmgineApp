//
//  LineView.m
//  Amazine
//
//  Created by Amgine on 13/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
    }
    return self;
}
-(void)drawLineWithColor:(UIColor *)color
{
    self.backgroundColor = color;
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
