//
//  ViewInfoVIew.m
//  Amgine
//
//  Created by Amgine on 30/06/14.
//   
//

#import "ViewInfoVIew.h"

@implementation ViewInfoVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}
-(void)drawImage:(NSString *)imageName
{
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame=CGRectMake(0, 0, 30, 30);
    [self addSubview:imageView];
}


@end
