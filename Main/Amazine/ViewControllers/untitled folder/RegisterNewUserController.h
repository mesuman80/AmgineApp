//
//  RegisterNewUserController.h
//  Amgine
//
//    on 16/08/14.
//  Copyright (c) 2014 MVN-Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IteratorViewController;
@interface RegisterNewUserController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property BOOL isNewUser;
@property IteratorViewController *iteratorViewController;
//@property UserLoginViewController *rootViewController;

@end
