//
//  CounrtyViewController.h
//  Amgine
//


#import <UIKit/UIKit.h>

@protocol CustomViewControllerDelegate <NSObject>
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath array:(NSArray *)selectedArray withTextField:(UITextField *)textField;
@end


@interface CustomViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property id<CustomViewControllerDelegate>delegate;
@property NSArray *displayData;
@property UITextField *textField;
@property NSString *objectType;
@end
