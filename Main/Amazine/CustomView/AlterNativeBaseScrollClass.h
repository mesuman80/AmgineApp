//
//  AlterNativeBaseScrollClass.h
//  Amgine
//
//  Created by Amgine on 17/07/14.
//   
//

#import <UIKit/UIKit.h>

//#import "UrlConnection.h"

@interface AlterNativeBaseScrollClass : UIView<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    float screenWidth;
    float screenHeight;
    float factor;
}
-(void)setScrollViewContentSize:(CGSize)size;
-(void)drawUI:(NSArray *)drawArray;
@property UIViewController *rootViewController;
@property UIView *cell;
@end
