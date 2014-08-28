//
//  TravelerViewController.h
//  Amgine
//
//  Created by Amgine on 26/06/14.
//   
//

#import <UIKit/UIKit.h>
#import "UrlConnection.h"

//#import

@class PassengerInfoCell;

@protocol TravelerViewControllerDelegate <NSObject>
-(void)returnFromTravelerViewController;
@end

@interface TravelerViewController : UIViewController<UITextFieldDelegate,UrlConnectionDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
-(IBAction)touchOnDoneButton:(id)sender;
-(IBAction)touchOnCancelButton:(id)sender;

@property NSString *passengerName;
@property PassengerInfoCell *passengerInfoCell;
@property id<TravelerViewControllerDelegate>delegate;

//@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end
