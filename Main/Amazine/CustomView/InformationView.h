//
//  InformationView.h
//  Amgine
//
//  Created by Amgine on 30/06/14.
//   
//

#import <UIKit/UIKit.h>

@interface InformationView : UIView<UIScrollViewDelegate>
-(void)drawImage:(NSString *)imageName;
@property UIImageView *infoImage;
@end
