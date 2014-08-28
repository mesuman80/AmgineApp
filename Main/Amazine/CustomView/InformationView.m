//
//  InformationView.m
//  Amgine
//
//  Created by Amgine on 30/06/14.
//   
//

#import "InformationView.h"

@implementation InformationView
{
   
}
@synthesize infoImage;

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
    [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
   [self addSubview:imageView];
     infoImage=imageView;
    
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
