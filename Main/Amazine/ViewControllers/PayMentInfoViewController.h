//
//  PayMentInfoViewController.h
//  Amgine
//
//  Created by Amgine on 26/06/14.
//   
//

#import <UIKit/UIKit.h>

@interface PayMentInfoViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
- (IBAction)touchOnCancelButton:(id)sender;
- (IBAction)touchOnDone:(id)sender;
@property NSArray *selectedData;
@end
