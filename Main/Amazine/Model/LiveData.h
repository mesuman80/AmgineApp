//
//  LiveData.h
//  Amgine
//
//  Created by Amgine on 07/07/14.
//   
//

#import <Foundation/Foundation.h>
@class Flight;
@class Hotel;
@class Contacts;
@class Passenger;
@class PaymentInfo;

@interface LiveData : NSObject
{
    
    
    
}

@property NSMutableDictionary *bookingDictionary;
@property NSMutableDictionary *passenInfoDictionary;
@property NSMutableDictionary *billingInfoDictionary;
@property NSMutableArray *hotelArray;
@property NSMutableArray *flightArray;
@property NSArray *passengerArray;
@property NSMutableDictionary *flightDictionary;
@property NSMutableDictionary *hotelDictionary;
@property NSMutableArray *selectedpassengerArray;
@property NSDictionary *bookingConfirmationDictionary;
@property BOOL isHotel;
//@property NSMutableDictionary *dictionaryAccToPassenger;
@property NSArray *dateArray;
@property NSString *solution_ID;
//@property NSMutableArray *dataAccToPassenger;
+(LiveData *)getInstance;
-(void)updateFlightArray:(Flight *)flight updateValue:(NSString *)upDateVal;
-(void)updateHotelArray:(Hotel *)hotel updateValue:(NSString *)upDateVal;
-(NSMutableDictionary *)savePassengerInfo:(Contacts *)contacts passenger_Id:(Passenger *)passenger;
-(void)savePaymentInfo:(PaymentInfo *)paymentInfo;
@end
LiveData *liveData;