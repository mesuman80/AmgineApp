//
//  SearchViewController.h
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextViewDelegate,UIScrollViewDelegate,NSURLConnectionDelegate>
-(IBAction)search:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property NSString *searchType;
@property NSString *searchingString;
-(void)setupConnection:(NSString *)searchString searchType:(NSString *)type isIndicatorNeed:(BOOL)isIndicator;
@property(strong,nonatomic)IBOutlet UIButton *searchButton;
@property(strong,nonatomic)IBOutlet UIScrollView *scrollView;


@end
