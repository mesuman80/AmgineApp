//
//  SwipeView.h
//  Amgine
//
//  Created by Amgine on 11/07/14.
//   
//

#import <UIKit/UIKit.h>

@interface SwipeView : UIView
{
    
}
@property UIImageView *imageView;
@property NSString *labelTextstr;
@property CGPoint swipePoint;
-(void)labelText:(NSString *)text;
-(void)updateLabelText:(NSString *)text;
-(void)detectTouches:(CGPoint)point;
-(void)displayFlightData:(NSDictionary *)dictionary;
-(void)resetFlightData;
-(void)displayHotelData:(NSDictionary *)hotelData;
-(void)resetHotelData;

@end
