//
//  VIewInfoViewController.h
//  Amgine
//
//  Created by Amgine on 30/06/14.
//   
//

#import <UIKit/UIKit.h>

@interface VIewInfoViewController : UIViewController<UIScrollViewDelegate>
-(IBAction)touchOnBackButton:(id)sender;
-(void)drawImage1:(UIImageView *)imageView;
@property UIImageView *imageView;
@end
