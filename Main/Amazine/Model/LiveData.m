    //
//  LiveData.m
//  Amgine
//
//  Created by Amgine on 07/07/14.
//   
//

#import "LiveData.h"
#import "Flight.h"
#import "Hotel.h"
#import "Contacts.h"
#import "Data.h"
#import "Passenger.h"
#import "PaymentInfo.h"
#import "BillingInfo.h"

@implementation LiveData
@synthesize hotelArray;
@synthesize flightArray;
@synthesize hotelDictionary;
@synthesize flightDictionary;
//@synthesize dictionaryAccToPassenger;
@synthesize passengerArray;
@synthesize dateArray;

@synthesize bookingDictionary;
@synthesize passenInfoDictionary;
@synthesize selectedpassengerArray;


@synthesize bookingConfirmationDictionary;

@synthesize isHotel;

//@synthesize <#property#>
//@synthesize dataAccToPassenger;

+(LiveData *)getInstance
{
    if(!liveData)
    {
        liveData=[[LiveData alloc]init];
        
    }
    return liveData;
}

-(id)init
{
    if(self=[super init])
    {
         liveData=self;
        hotelDictionary=[[NSMutableDictionary alloc]init];
        flightDictionary=[[NSMutableDictionary alloc]init];
        isHotel=NO;
       // bookingDictionary=[[NSMutableDictionary alloc]init];
       
        
    }
    return self;
}
-(void)updateFlightArray:(Flight *)flight updateValue:(NSString *)upDateVal
{
    
    int index=0;
    for(Flight *flights in [LiveData getInstance].flightArray)
    {
        if(flights==flight)
        {
            flights.isalternative=upDateVal;
            [[[LiveData getInstance]flightArray]removeObject:flights];
            [[[LiveData getInstance]flightArray]insertObject:flights atIndex:index];
            break;
        }
        index++;
    }
}

-(void)updateHotelArray:(Hotel *)hotel updateValue:(NSString *)upDateVal
{
    int index=0;
    for(Hotel *hotels in [LiveData getInstance].hotelArray)
    {
        if(hotels==hotel)
        {
             hotels.isalternative=upDateVal;
             [[[LiveData getInstance]hotelArray]removeObject:hotels];
             [[[LiveData getInstance]hotelArray]insertObject:hotels atIndex:index];
            break;
        }
        index++;
    }
}
-(NSMutableDictionary *)savePassengerInfo:(Contacts *)contacts passenger_Id:(Passenger *)passenger
{
    if(passenInfoDictionary)
    {
        passenInfoDictionary=[[NSMutableDictionary alloc]init];
    }
    
    NSString *dateStr=[[Data sharedData]getDateStr:contacts.dob format:@"yyyyMMdd"];
    NSString *genderStr=nil;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setObject:passenger.paxguid forKey:@"paxguid"];
    [dictionary setObject:contacts.title forKey:@"title"];
    [dictionary setObject:contacts.firstName forKey:@"firstname"];
    [dictionary setObject:contacts.lastname forKey:@"lastname"];
    [dictionary setObject:contacts.postal_code forKey:@"postalcode"];
    // Female
    if([contacts.gender isEqualToString:@"Female"])
    {
        genderStr=@"F";
    }
    else
    {
        genderStr=@"M";
    }
    [dictionary setObject:genderStr forKey:@"gender"];
    [dictionary setObject:contacts.phone_Mobile forKey:@"phonemobile"];
    [dictionary setObject:contacts.phone_Home forKey:@"phonehome"];
    [dictionary setObject: contacts.address forKey:@"address1"];
    [dictionary setObject: contacts.city forKey:@"city"];
    [dictionary setObject: contacts.provinceCode forKey:@"province"];
    
    NSLog(@"Value of CountryCode=%@",contacts.country_Code);
    
    [dictionary setObject:contacts.country_Code forKey:@"country"];
    [dictionary setObject:dateStr forKey:@"dob"];
    [dictionary setObject: contacts.email forKey:@"email"];
    [[LiveData getInstance].passenInfoDictionary setObject:dictionary forKey:passenger.name];
    //NSLog(@"%@",passengerInfoCell.passenger_Name);
    return dictionary;
}

-(void)savePaymentInfo:(PaymentInfo *)paymentInfo
{
    if(!self.billingInfoDictionary)
    {
         self.billingInfoDictionary=[[NSMutableDictionary alloc]init];
    }
    
//    NSDate *date=paymentInfo.expire_date;
//    NSString *str=[[Data sharedData]getDateStr:date format:@"yy-MM-dd"];
//    NSArray *arr=[str componentsSeparatedByString:@"-"];
    
  //  NSLog(@"Value of date=%@",date);
    [[LiveData getInstance].billingInfoDictionary setValue:paymentInfo.first_Name forKey:@"firstname"];
    [[LiveData getInstance].billingInfoDictionary setValue:paymentInfo.last_Name forKey:@"lastname"];
    [[LiveData getInstance].billingInfoDictionary setValue:paymentInfo.credit_Type_Number forKey:@"cardnumber"];
    [[LiveData getInstance].billingInfoDictionary setValue:@"111" forKey:@"cvv"];
  //  [[LiveData getInstance].billingInfoDictionary setValue:paymentInfo.provinceCode forKey:@"province"];
    
    NSString *cardType=nil;
    if([paymentInfo.credit_Card_Type isEqualToString:@"Visa"])
    {
        cardType=@"2";
    }
    else if([paymentInfo.credit_Card_Type isEqualToString:@"MasterCard"])
    {
        cardType=@"3";
    }
    else
    {
         cardType=@"1";
    }
    [[LiveData getInstance].billingInfoDictionary setValue:cardType forKey:@"cardtype"];
    [[LiveData getInstance].billingInfoDictionary setValue:paymentInfo.month forKey:@"expirymonth"];
    [[LiveData getInstance].billingInfoDictionary setValue:paymentInfo.year forKey:@"expiryyear"];
    NSLog(@"value of Dictionary=%@",[LiveData getInstance].billingInfoDictionary);
}



@end
