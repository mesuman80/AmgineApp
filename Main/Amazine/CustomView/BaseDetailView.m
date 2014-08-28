//
//  BaseDetailView.m
//  Amgine
//

//

#import "BaseDetailView.h"
#import "ScreenInfo.h"
#import "Data.h"

@implementation BaseDetailView
@synthesize rootViewController;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        factor=[ScreenInfo getScreenHeight]/568.0f;
        [self drawCancelButton];
        [[Data sharedData]addDeatilView:YES view:self];
        
    }
    return self;
}


-(void)drawCancelButton
{
     UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(250,factor*48,60,30)];
    [cancelButton setTitleColor:[Data sharedData].buttonColor forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchUpInside];
   // [cancelButton setBackgroundColor:[UIColor redColor]];
    [self addSubview:cancelButton];
}

-(void)touchCancel:(id)sender
{
    self.rootViewController.parentView .center=CGPointMake(320/2,self.rootViewController.parentView.center.y);
    
   [UIView animateWithDuration:0.4 animations:^{
        [self setAlpha:0.0f];
        rootViewController.parentView.alpha=1.0f;
    } completion:^(BOOL finished)
    {
       
        [self viewDisappear];
        [self removeFromSuperview];
        [[Data sharedData]addDeatilView:NO view:nil];
    }];
    
}
-(void)viewDisappear
{
  
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
