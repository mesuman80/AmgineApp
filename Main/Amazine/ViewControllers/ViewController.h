//
//  ViewController.h
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

-(IBAction)speechRequest:(id)sender;
-(IBAction)typeRequest:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)IBOutlet UIButton *buttonTypeRequest;
@property(strong,nonatomic)IBOutlet UIButton *buttonSpeechRequest;
- (IBAction)TouchOnLoginButton:(id)sender;


@end
