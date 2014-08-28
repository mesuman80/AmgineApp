//
//  BaseDetailView.h
//  Amgine
//

//

#import <UIKit/UIKit.h>
#import "IteratorViewController.h"

@interface BaseDetailView : UIView
{
    float factor;
}
@property IteratorViewController *rootViewController;
-(void)viewDisappear;
-(void)drawCancelButton;
@end
