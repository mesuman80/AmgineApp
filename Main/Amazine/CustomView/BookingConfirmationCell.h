//
//  BookingConfirmationCell.h
//  Amgine
//

#import <UIKit/UIKit.h>
#import "UrlConnection.h"

@interface BookingConfirmationCell : UIView<UrlConnectionDelegate>
-(void)configureBookingFlightCell;
-(void)configureBookingHotelCell;
@property NSDictionary *responseDictionary;


@end
