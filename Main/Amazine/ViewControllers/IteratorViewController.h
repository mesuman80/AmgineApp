//
//  ResultViewController.h
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IteratorViewController : UIViewController<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchingBar;
@property (nonatomic,retain)NSString *solutionid;
@property (nonatomic,retain)UIView *parentView;
-(void)gotoPassengerInfoScreen;
-(void)cleanArray;

@end
