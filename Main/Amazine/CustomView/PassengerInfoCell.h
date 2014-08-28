//
//  passengerInfoCell.h
//  Amgine
//
//   on 31/07/14.
//   
//

#import <UIKit/UIKit.h>
#import "PassengerInfoController.h"

@class Passenger;

@interface PassengerInfoCell:UITableViewCell
-(void)configureCell:(NSString *)name;

-(void)drawTickImage;
-(void)resetImage;
@property BOOL is_Touch;
@property BOOL is_Image;
@property NSString *passenger_Name;
@property Passenger *passenger;
@property PassengerInfoController *passengerInfoController;
@end
