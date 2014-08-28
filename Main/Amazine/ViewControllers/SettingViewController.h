//
//  SettingViewController.h
//  Amgine
//
//  Created by Amgine on 18/07/14.
//   
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)TouchOnCancel:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *settingTableView;

 
@end
