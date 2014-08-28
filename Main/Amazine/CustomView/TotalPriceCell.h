//
//  TotalPrice.h
//  Amgine
//
//  Created by Amgine on 20/06/14.
//   
//

#import <UIKit/UIKit.h>

@interface TotalPriceCell : UIView
-(void)drawRectangle:(CGRect)rectanglRect Color:(UIColor *)color;
-(void)drawImage;
-(void)drawTotalPrice:(NSString *)price;
-(void)drawDate:(NSString *)date is_Single:(BOOL)is_Single;
-(void)drawPlaceName:(NSString *)value;
-(void)updateTotalCost:(NSString *)cost;
@property CGRect rectangleRect;


@end
