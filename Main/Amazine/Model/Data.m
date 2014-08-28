




//
//  Data.m
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "Data.h"
#import "Constants.h"
#import "Passenger.h"
#import "Hotel.h"
#import "Flight.h"
#import "Flightleg.h"
#import "ContactData.h"
#import "LiveData.h"
#import "IteratorViewController.h"
#import "FlightID.h"
#import "HotelId.h"
#import "ProfileInfo.h"
#import "RegisterNewUser.h"
#import "BillingInfo.h"
#import "CreateAccountInfo.h"




@implementation Data
@synthesize getContext;
@synthesize colorCodeArray;
@synthesize viewColorArray;
@synthesize buttonDisplayName, lastDeleteCell,undoImage;
@synthesize passengerScreen;
@synthesize deleteIndex;
@synthesize reviewTipDisplayArray;
@synthesize borderViewArray;
@synthesize buttonColor;
@synthesize selectedPassengerIndex;
@synthesize selectedCellIndex;
@synthesize colorpeletteCode;
@synthesize countryArray;
@synthesize userLoginProfileInfo;
@synthesize isUserLogin;
@synthesize detailViewContainer;

+(Data *)sharedData
{
    if(dataInstance==nil)
    {
        dataInstance=[[Data alloc]init];
    }
    return dataInstance;
}
-(id)init
{
    if(self=[super init])
    {
        getContext=[self getContext];
        viewColorArray=[[NSMutableArray alloc]initWithObjects:[UIColor grayColor],[UIColor redColor], nil];
        buttonDisplayName=[[NSMutableArray alloc]initWithObjects:@"NEXT",@"DELETE", nil];
        buttonColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        selectedCellIndex=-1;
        colorpeletteCode=[[NSMutableArray alloc]init];
        [colorpeletteCode addObject:[[NSArray alloc]initWithObjects:[self colorFromHex:@"36858C"],[self colorFromHex:@"145e60"], nil]];
        [colorpeletteCode addObject:[[NSArray alloc]initWithObjects:[self colorFromHex:@"C30075"],[self colorFromHex:@"7f2148"], nil]];
        
    }
    return self;
}
#pragma mark BorderSpecific Function
-(void)addBorderToButton:(UIButton *)button
{
    [button.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [button.layer setBorderWidth:2.0];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
}
-(void)addBorderToTextView:(UITextView *)textView
{
    [textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [textView.layer setBorderWidth:2.0];
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
}
-(void)addBorderToUiView:(UIView *)view
{
    [view.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [view.layer setBorderWidth:2.0];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
}
-(void)addImageBorder:(UIImageView *)view
{
    [view.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [view.layer setBorderWidth:2.0];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
}

#pragma mark getManageObject Instance
-(AppDelegate *)appDelegateInstance
{
     return[UIApplication sharedApplication].delegate;
       
}
-(NSManagedObjectContext *)getContext
{
    AppDelegate *appDelegate=[self appDelegateInstance];
    return appDelegate.managedObjectContext;
}

#pragma mark getValueAccToEntityName
-(NSArray*)getArrayFromEntity:(NSString *)entityName
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:getContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [getContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}
//-(NSSet *)getPassengerArray:(NSMutableArray *)fetchObject
//{
////    Solution_Id * solution_id =[fetchObject objectAtIndex:0];
////    return solution_id.passenger;
//    return nil;
//}
//
//-(NSSet *)getHotelArray:(NSMutableArray *)fetchObject
//{
////    Solution_Id * solution_id =[fetchObject objectAtIndex:0];
////    return solution_id.hotel;
//     return nil;
//}
//-(NSSet *)getFlightArray:(NSMutableArray *)fetchObject
//{
////    Solution_Id * solution_id =[fetchObject objectAtIndex:0];
////    return solution_id.flights;
//     return nil;
//}
//
//-(NSSet *)getFlightLegArray:(NSMutableArray *)fetchObject
//{
////    Solution_Id * solution_id =[fetchObject objectAtIndex:0];
////    return solution_id.flightlegs;
//     return nil;
//}
-(Response *)getResponse:(NSMutableArray *)fetchObject
{
//    Solution_Id * solution_id =[fetchObject objectAtIndex:0];
//    return solution_id.response;
     return nil;
}

#pragma mark SaveDataToLocal
-(void)saveSolutionEntity:(NSString *)solution_id withResponse:(NSArray *)responseArray
{
    BOOL is_Exist=NO;
    NSArray *solutionArray=[self getArrayFromEntity:AmgineSolution_idEntity];
    Solution_Id *solutionObject=nil;
    for(Solution_Id *solution in solutionArray)
    {
        if([solution.solutionid isEqualToString:solution_id])
        {
            is_Exist=YES;
            solutionObject=solution;
            break;
        }
    }
    if(!is_Exist)
    {
        
        solutionObject =[NSEntityDescription insertNewObjectForEntityForName:AmgineSolution_idEntity inManagedObjectContext:getContext];
    }
      solutionObject.solutionid=solution_id;
    
       LiveData *liveData1=[[LiveData alloc]init];
       liveData1.solution_ID =solution_id;
    
     [self addResponse:responseArray withObject:solutionObject boolVal:is_Exist];
    
    
   NSMutableArray *responseArr=  [[[solutionObject response]array]mutableCopy];
    
    NSMutableArray *dateArray=[[Data sharedData]getDateArray:[responseArr objectAtIndex:0]];
    Response *response=[responseArr objectAtIndex:0];
    [self getAllDataArrayWithPassengerArray:[[response passenger]array] WithResponse:response WithDateArray:dateArray];
    
    [self writeToDisk];
    
    
    
}
-(void)writeToDisk
{
    NSError *error=nil;
    @try {
        if (![getContext save:&error])
        {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            
        }
        else
        {
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"value Exception:%@",exception.description);
    }
    @finally {
        
    }
    

}
-(void)savePassengerDataToLocal:(NSArray *)passengerArray withObject:(Response *)responseObject WithBoolVal:(BOOL)isExist
{
    NSMutableOrderedSet *passengerSet=[[NSMutableOrderedSet alloc]init];
    int i=0;
    for(NSMutableDictionary *passengerDictionary in passengerArray)
    {
        Passenger *passengers=nil;
        if(isExist)
        {
            passengers=[[responseObject passenger]objectAtIndex:i];
            
        }
        else{
             passengers=[NSEntityDescription insertNewObjectForEntityForName:AmginePassengerEntity inManagedObjectContext:getContext];
        }
       
        passengers.paxguid=[passengerDictionary valueForKey:@"paxguid"];
        passengers.name=[passengerDictionary valueForKey:@"name"];
        passengers.index=[NSString stringWithFormat:@"%i",i];
        NSArray *flight=[passengerDictionary valueForKey:@"flights"];
        NSMutableOrderedSet *flightSet=[[NSMutableOrderedSet alloc]init];
        
        int flightIndex=0;
        for(NSString *str in flight)
        {
            FlightID *flightId=nil;
           if(isExist)
           {
               flightId=[passengers.flightIdArray objectAtIndex:flightIndex];
           }
           else
            {
               flightId=[NSEntityDescription insertNewObjectForEntityForName:AmgineFlightId inManagedObjectContext:getContext];
            }
            flightId.flightId=str;
            [flightSet addObject:flightId];
            flightIndex++;
        }
         passengers.flightIdArray=flightSet;
        //passengers.flights=flight;
        NSArray *hotels=[passengerDictionary valueForKey:@"hotels"];

        NSMutableOrderedSet *hotelSet=[[NSMutableOrderedSet alloc]init];
        
        int hotelIndex=0;
        for(NSString *str in hotels)
        {
            HotelId *hotelId=nil;
            if(isExist)
            {
                hotelId=[passengers.hotelIdArray objectAtIndex:hotelIndex];
            }
            else
            {
                hotelId=[NSEntityDescription insertNewObjectForEntityForName:AmgineHotelId inManagedObjectContext:getContext];

            }
            hotelId.hotelId=str;
            [hotelSet addObject:hotelId];
            hotelIndex++;
        }
        passengers.hotelIdArray=hotelSet;
        i++;
        [passengerSet addObject:passengers];
    }
   
    responseObject.passenger=passengerSet;
   
    passengerSet=nil;
    
}
-(void)saveHotelDataToLocal:(NSArray *)hotelArray withObject:(Response *)responseObject WithBoolVal:(BOOL)isExist
{
    int i=0;
    NSMutableOrderedSet *hotelSet=[[NSMutableOrderedSet alloc]init];
    for(NSMutableDictionary *hotelDictionary in hotelArray)
    {
        Hotel *hotels=nil;
        if(isExist)
        {
            hotels=[[responseObject hotel]objectAtIndex:i];
            
        }
        else{
         hotels=[NSEntityDescription insertNewObjectForEntityForName:AmgineHotelEntity inManagedObjectContext:getContext];
        }

        
        hotels.hotelcode=[hotelDictionary valueForKey:@"hotelcode"];
        NSLog(@"value of HotelCode=%@",hotels.hotelcode);
        hotels.citycode=[hotelDictionary valueForKey:@"citycode"];
         NSLog(@"value of cityCode=%@",hotels.citycode);
        hotels.hotelname=[hotelDictionary valueForKey:@"hotelname"];
        NSLog(@"value of HotelName=%@",hotels.hotelname);
        hotels.hotelchain=[hotelDictionary valueForKey:@"hotelchain"];
         NSLog(@"value of hotelchain=%@",hotels.hotelchain);
        hotels.starrating=[[hotelDictionary valueForKey:@"starrating"]stringValue];
         NSLog(@"value of starrating=%@",hotels.starrating);
        hotels.shortdescription=[hotelDictionary valueForKey:@"shortdescription"];
          NSLog(@"value of shortdescription=%@",hotels.shortdescription);
        hotels.locationdescription=[hotelDictionary valueForKey:@"locationdescription"];
         NSLog(@"value of locationDescription=%@",hotels.locationdescription);
        hotels.postalcode=[hotelDictionary valueForKey:@"postalcode"];
         NSLog(@"value of postalcode=%@",hotels.postalcode);
        hotels.latitude=[[hotelDictionary valueForKey:@"latitude"]stringValue];
         NSLog(@"value of latitude=%@",hotels.latitude);
        hotels.longitude=[[hotelDictionary valueForKey:@"longitude"]stringValue];
         NSLog(@"value of longitude=%@",hotels.longitude);
        hotels.address1=[hotelDictionary valueForKey:@"address1"];
         NSLog(@"value of address1=%@",hotels.address1);
        hotels.address2=[hotelDictionary valueForKey:@"address2"];
         NSLog(@"value of address2=%@",hotels.address2);
        hotels.address3=[hotelDictionary valueForKey:@"address3"];
         NSLog(@"value of address3=%@",hotels.address3);
        hotels.phone=[hotelDictionary valueForKey:@"phone"];
         NSLog(@"value of phone=%@",hotels.phone);
        hotels.image=[hotelDictionary valueForKey:@"image"];
         NSLog(@"value of image=%@",hotels.image);
        hotels.amenities=[hotelDictionary valueForKey:@"amenities"];
         NSLog(@"value of amenities=%@",hotels.amenities);
        hotels.minimumamount=[[hotelDictionary valueForKey:@"minimumamount"]stringValue];
         NSLog(@"value of minimumamount=%@",hotels.minimumamount);
        hotels.maximumamount=[[hotelDictionary valueForKey:@"maximumamount"]stringValue];
         NSLog(@"value of maximumamount=%@",hotels.maximumamount);
        hotels.checkin=[hotelDictionary valueForKey:@"checkin"];
         NSLog(@"value of checkin=%@",hotels.checkin);
        hotels.checkout=[hotelDictionary valueForKey:@"checkout"];
         NSLog(@"value of checkout=%@",hotels.checkout);
        hotels.cost=[[hotelDictionary valueForKey:@"cost"]stringValue];
         NSLog(@"value of cost=%@",hotels.cost);
        hotels.roomtype=[hotelDictionary valueForKey:@"roomtype"];
         NSLog(@"value of roomtype=%@",hotels.roomtype);
        hotels.chain=[hotelDictionary valueForKey:@"chain"];
         NSLog(@"value of chain=%@",hotels.chain);
        hotels.city=[hotelDictionary valueForKey:@"city"];
         NSLog(@"value of city=%@",hotels.city);
        hotels.guid=[hotelDictionary valueForKey:@"guid"];
         NSLog(@"value of guid=%@",hotels.guid);
        hotels.paxguid=[hotelDictionary valueForKey:@"paxguid"];
         NSLog(@"value of paxguid=%@",hotels.paxguid);
        hotels.isalternative=[[hotelDictionary valueForKey:@"isalternative"]stringValue];
         NSLog(@"value of isalternative=%@",hotels.isalternative);
        hotels.stateProvince=[hotelDictionary valueForKey:@"stateprovince"];
         NSLog(@"value of stateProvince=%@",hotels.stateProvince);
        hotels.roomCode=[hotelDictionary valueForKey:@"roomcode"];
         NSLog(@"value of roomCode=%@",hotels.roomCode);
        hotels.country=[hotelDictionary valueForKey:@"country"];
         NSLog(@"value of country=%@",hotels.country);
        
        [hotelSet addObject:hotels];
        i++;
       
    }
    
     responseObject.hotel=hotelSet;
     hotelSet=nil;
    
}

-(void)saveFlightDataToLocal:(NSArray *)flightArray withObject:(Response *)responseObject WithBoolVal:(BOOL)isExist
{
    NSMutableOrderedSet *flightSet=[[NSMutableOrderedSet alloc]init];
    int i=0;
    for(NSMutableDictionary *flightDictionary in flightArray)
    {
        Flight *flights=nil;
        if(isExist)
        {
            flights=[[responseObject flight]objectAtIndex:i];
            
        }
        else{
             flights=[NSEntityDescription insertNewObjectForEntityForName:AmgineFlightsEntity inManagedObjectContext:getContext];
        }

      
        flights.isalternative =[[flightDictionary valueForKey:@"isalternative"]stringValue];
        flights.guid  = [flightDictionary valueForKey:@"guid"];
        flights.flightnumber =[flightDictionary valueForKey:@"flightnumber"];
        NSLog(@"value of FLightTime=%@",[flightDictionary valueForKey:@"flightTime"]);
        flights.flighttime =[[flightDictionary valueForKey:@"flighttime"]stringValue];
        flights.departure =[flightDictionary valueForKey:@"departure"];
        flights.arrival  =[flightDictionary valueForKey:@"arrival"];
        flights.origin=[flightDictionary valueForKey:@"origin"];
        flights.destination=[flightDictionary valueForKey:@"destination"];
        flights.carrier=[flightDictionary valueForKey:@"carrier"];
        flights.equipment=[flightDictionary valueForKey:@"equipment"];
        flights.seatclass=[flightDictionary valueForKey:@"seatClass"];
        flights.cost=[[flightDictionary valueForKey:@"cost"]stringValue];
        flights.legs=[[flightDictionary valueForKey:@"legs"]stringValue];
        flights.traveltime=[[flightDictionary valueForKey:@"traveltime"]stringValue];
        flights.paxguid=[flightDictionary valueForKey:@"paxguid"];
        flights.travelsector=[flightDictionary valueForKey:@"travelsector"];
        flights.availableFlightId=[[flightDictionary valueForKey:@"availableflightid"]stringValue];
        [flightSet addObject:flights];
        i++;
    }
    responseObject.flight=flightSet;
    flightSet=nil;

}
-(void)saveFlightlegsDataToLocal:(NSArray *)flightlegsArray withObject:(Response *)responseObject WithBoolVal:(BOOL)isExist
{
     NSMutableOrderedSet *flightlegsSet=[[NSMutableOrderedSet alloc]init];
      int i=0;
    for(NSMutableDictionary *flightlegsDictionary in flightlegsArray)
    {
        Flightleg *flightlegs=nil;
        if(isExist)
        {
            flightlegs=[[responseObject flightleg]objectAtIndex:i];
            
        }
        else{
             flightlegs=[NSEntityDescription insertNewObjectForEntityForName:AmgineFlightlegsEntity inManagedObjectContext:getContext];
        }

      
        flightlegs.parentguid =[flightlegsDictionary valueForKey:@"parentguid"];
        flightlegs.guid  = [flightlegsDictionary valueForKey:@"guid"];
        flightlegs.flightnumber =[flightlegsDictionary valueForKey:@"flightnumber"];
        flightlegs.flighttime =[[flightlegsDictionary valueForKey:@"flighttime"]stringValue];
        flightlegs.departure =[flightlegsDictionary valueForKey:@"departure"];
        flightlegs.departures=[flightlegsDictionary valueForKey:@"departures"];
        flightlegs.arrival  =[flightlegsDictionary valueForKey:@"arrival"];
        flightlegs.arrivals  =[flightlegsDictionary valueForKey:@"arrivals"];
        flightlegs.code  =[flightlegsDictionary valueForKey:@"code"];
        flightlegs.origin=[flightlegsDictionary valueForKey:@"origin"];
        flightlegs.destination=[flightlegsDictionary valueForKey:@"destination"];
        flightlegs.carrier=[flightlegsDictionary valueForKey:@"carrier"];
        flightlegs.equipment=[flightlegsDictionary valueForKey:@"equipment"];
        flightlegs.cost=[[flightlegsDictionary valueForKey:@"cost"]stringValue];
        flightlegs.paxguid=[flightlegsDictionary valueForKey:@"paxguid"];
        flightlegs.ref=[[flightlegsDictionary valueForKey:@"ref"]stringValue];
        flightlegs.seq=[[flightlegsDictionary valueForKey:@"seq"]stringValue];
        [flightlegsSet addObject:flightlegs];
        i++;
    }
    
    responseObject.flightleg=flightlegsSet;
    flightlegsSet=nil;
    
}
-(void)addResponse:(NSArray *)responseArray withObject:(Solution_Id *)solutionObject boolVal:(BOOL)isExist
{
    NSMutableOrderedSet *responseSet=[[NSMutableOrderedSet alloc]init];
    for(int i=0;i<responseArray.count;i++)
    {
        Response *response=nil;
        if(isExist)
        {
            response=[[solutionObject response]objectAtIndex:i];
           
        }
        else
        {
            response=[NSEntityDescription insertNewObjectForEntityForName:AmgineResponseEntity inManagedObjectContext:getContext];
        }
       
         NSMutableDictionary *responseDictionary=[responseArray objectAtIndex:i];
         NSMutableDictionary *responseDictionary1=[responseDictionary objectForKey:@"response"];
        response.tbc=[[responseDictionary valueForKey:@"tbc"]stringValue];
        response.index=[NSString stringWithFormat:@"%i",i];
        if(i==1)
        {
            response.eventname=[responseDictionary1 valueForKey:@"eventName"];
    
        }
        else
        {
           
            NSArray *passenger=[responseDictionary1 valueForKey:@"passengers"];
            NSArray *hotel=[responseDictionary1 valueForKey:@"hotels"];
            NSArray *flightleg=[responseDictionary1 valueForKey:@"flightlegs"];
            NSArray *flight=[responseDictionary1 valueForKey:@"flights"];
            [self savePassengerDataToLocal:passenger withObject:response WithBoolVal:isExist];
            [self saveHotelDataToLocal:hotel withObject:response WithBoolVal:isExist];
            [self saveFlightDataToLocal:flight withObject:response WithBoolVal:isExist];
            [self saveFlightlegsDataToLocal:flightleg withObject:response WithBoolVal:isExist];
        }
       
       
        [responseSet addObject:response];
    }
    solutionObject.response=responseSet;
 
}

-(void)saveContactData:(NSMutableDictionary *)contactsDictionary name:(NSString *)name
{
    
}
-(Solution_Id *)getSolutionId:(NSString *)soloutionId fromArray:(NSMutableArray *)arr
{
    for(Solution_Id *solution in arr)
    {
        if([solution.solutionid isEqualToString:soloutionId])
        {
             return solution;
        }
       
    }
    return nil;
}



-(NSMutableArray*)dataByID:(NSString *)passenger_id withDateArray:(NSMutableArray *)dateArray WithResponse:(Response *)response
{
    NSMutableArray *hotelAndFlightArray=[[NSMutableArray alloc]init];
    
    for(NSString *date in dateArray)
    {
        NSMutableArray *flightAndHotelStorage=[[NSMutableArray alloc]init];
         NSString *date1=[date substringToIndex:10];
        for(Flight *flight in response.flight)
        {
            NSLog(@"Value of Date=%@",date);
          
            if([self stringContain:flight.departure withDateString:date1])
            {
                if([flight.paxguid isEqualToString:passenger_id])
                {
                    if([flight.isalternative isEqualToString:@"0"])
                    {
                        [flightAndHotelStorage addObject:flight];
                    }
                }
            }
        }
        
        for(Hotel *hotel in response.hotel)
        {
            NSLog(@"i am in hotel lop");
            if([self stringContain:hotel.checkin withDateString:date1])
            {
                if([hotel.paxguid isEqualToString:passenger_id])
                {
                    
                    if([hotel.isalternative isEqualToString:@"0"])
                    {
                        [flightAndHotelStorage addObject:hotel];
                    }
                }
            }
        }
        if(flightAndHotelStorage && flightAndHotelStorage.count>0)
        {
            [hotelAndFlightArray addObject:flightAndHotelStorage];
        }
    }
    
    return hotelAndFlightArray;
}

-(void)getAllDataArrayWithPassengerArray:(NSArray *)passengerArray WithResponse:(Response *)response WithDateArray:(NSArray *)dateArray
{
   
    NSMutableArray *flightArray=[[NSMutableArray alloc]init];
    NSMutableArray *hotelArray=[[NSMutableArray alloc]init];
   
    
    
   
    [LiveData getInstance].dateArray=dateArray;
    for(NSString *date in dateArray)
    {
        NSString *date1=[date substringToIndex:10];
     //   NSMutableArray *hotelAccDate=[[NSMutableArray alloc]init];
    //    NSMutableArray *flightAccDate=[[NSMutableArray alloc]init];
       for(Flight *flight in response.flight)
        {
            NSLog(@"flight departure=%@",flight.guid);
            if([self stringContain:flight.departure withDateString:date1])
            {
               
                [flightArray addObject:flight];
                //[flightAccDate addObject:flight];
                
            }
         }
//        if(flightAccDate.count>0)
//        {
//           // [liveData.flightDictionary setObject:flightAccDate forKey:date];
//        }
       for(Hotel *hotel in response.hotel)
        {
           
            if([self stringContain:hotel.checkin withDateString:date1])
            {
                [hotelArray addObject:hotel];
               // [hotelAccDate addObject:hotel];
            }
            
        }
//        if(hotelAccDate.count>0)
//        {
//            //[liveData.hotelDictionary setObject:hotelAccDate forKey:date];
//        }
        
       
   }
    
    if(flightArray)
    {
          [LiveData getInstance].flightArray=flightArray;
        
    }
    if(hotelArray)
    {
          [LiveData  getInstance].hotelArray=hotelArray;
    }
    if(passengerArray)
    {
          [LiveData getInstance].passengerArray=passengerArray;
    }
    
    
        
    
    //******change
    
 
//   NSMutableDictionary *passengerData=[[NSMutableDictionary alloc]init];
//   for(Passenger *passenger in passengerArray)
//   {
//       NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
//       NSMutableArray *flightArray=[[NSMutableArray alloc]init];
//       NSMutableArray *hotelArray=[[NSMutableArray alloc]init];
//       for(Flight *flight in response.flight)
//       {
//           if([passenger.paxguid isEqualToString:flight.paxguid])
//           {
//               [flightArray addObject:flight];
//           }
//       }
//       for(Hotel *hotel in response.hotel)
//       {
//           if([passenger.paxguid isEqualToString:hotel.paxguid])
//           {
//                [hotelArray addObject:hotel];
//           }
//       }
//       
//       [dictionary setObject:flightArray forKey:@"flight"];
//       [dictionary setObject:hotelArray forKey:@"hotel"];
//       [passengerData setObject:dictionary forKey:passenger.paxguid];
//     //  [liveData.dataAccToPassenger addObject:passengerData];
//   }
// 
// //*******change****//
//   NSString *passengerId=nil;
//   for(int i=0;i<passengerArray.count;i++)
//   {
//        passengerId=[[passengerArray objectAtIndex:i]paxguid];
//      //  NSDictionary *dict =[self getPassengerData:passengerId withIndex:i];
//    //   [liveData.dictionaryAccToPassenger setObject:dict forKey:passengerId];
//   }
// 
   
    
}

//*****change//


//-(NSMutableDictionary *)getPassengerData:(NSString *)passengerId withIndex:(int)index
//{
//   NSDictionary*dictionary =[liveData.dataAccToPassenger objectAtIndex:index];
//   NSDictionary *passengerDictionary=[dictionary objectForKey:passengerId];
//   NSArray *flightArray=[passengerDictionary objectForKey:@"flight"];
//   NSArray *hotelArray=[passengerDictionary objectForKey:@"hotel"];
//    NSMutableDictionary *passengerHotelDictionary =[[NSMutableDictionary alloc]init];
//    NSMutableDictionary *passengerflightDictionary =[[NSMutableDictionary alloc]init];
//    
//    for(NSString *date in liveData.dateArray)
//    {
//        NSMutableArray *hotelAccDate=[[NSMutableArray alloc]init];
//        NSMutableArray *flightAccDate=[[NSMutableArray alloc]init];
//        for(Flight *flight in flightArray)
//        {
//            if([flight.paxguid isEqualToString:passengerId])
//            {
//                if([self stringContain:flight.departure withDateString:date])
//                {
//                  [flightAccDate addObject:flight];
//                }
//            }
//        }
//        if(flightAccDate.count>0)
//        {
//            [passengerflightDictionary setObject:flightAccDate forKey:date];
//        }
//        
//        for(Hotel *hotel in hotelArray)
//        {
//            if([hotel.paxguid isEqualToString:passengerId])
//            {
//              if([self stringContain:hotel.checkin withDateString:date])
//              {
//                 [hotelAccDate addObject:hotel];
//              }
//            }
//        }
//        if(hotelAccDate.count>0)
//        {
//            [passengerHotelDictionary setObject:hotelAccDate forKey:date];
//        }
//    }
//     NSMutableDictionary *parentDictionary=[[NSMutableDictionary alloc]init];
//    [parentDictionary setObject:passengerHotelDictionary forKey:@"Hotel"];
//    [parentDictionary setObject:passengerflightDictionary forKey:@"Flight"];
//    return parentDictionary;
//}


-(NSDictionary *)getFlightData:(NSString *)passengerId
{
    NSMutableDictionary *flightData=[[ NSMutableDictionary alloc]init];
    NSArray *dateArray=[LiveData getInstance].dateArray;
    for(NSString *date in dateArray)
    {
        NSArray *flightArray=[[[LiveData getInstance]flightDictionary]objectForKey:date];
        for(Flight *flight in flightArray)
        {
            if([flight.paxguid isEqualToString:passengerId])
            {
                
            }
        }
    }
    return flightData;
}


-(NSMutableArray *)getAllHotelArrayWithPassengerArray:(NSMutableArray *)passengerArray WithResponse:(Response *)response
{
    NSMutableArray *hotelArray=[[NSMutableArray alloc]init];
    for(Passenger *passenger in passengerArray)
    {
        for(Hotel * hotel in response.hotel)
        {
            if([passenger.paxguid isEqualToString:hotel.paxguid])
            {
                [hotelArray addObject:hotel];
            }
        }
    }
    
    return hotelArray;
}
-(NSMutableArray*)flightsByID:(NSString *)passenger_id withSolution:(Solution_Id *)solutionObject WithResponse:(Response *)response
{
    NSMutableArray *flightArray=[[NSMutableArray alloc]init];
    for(Flight *flight in response.flight)
    {
        if([flight.paxguid isEqualToString:passenger_id])
        {
            [flightArray addObject:flight];
        }
    }
    return flightArray;
    //return nil;
}
#pragma mark getDateFromString
-(NSString *)getDateFormat:(NSString *)dateFormat withDateString:(NSString *)dateStr dateFormat:(NSString *)format
{
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:dateFormat];
     NSDate *date = [dateFormatter dateFromString:dateStr];
     dateFormatter.dateFormat =format;
     return [dateFormatter stringFromDate:date];//dateStr;
}

-(NSString *)getDateStr:(NSDate *)date format:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *strDate = [dateFormatter stringFromDate:date];
    NSLog(@"%@", strDate);
    return strDate;
}
#pragma mark Arrange Data Acc. to date and IsAlternative
-(NSMutableArray *)arrangeHotelDataAccToDate:(Solution_Id *)solutionObject
{
//    NSSet *hotelSet=solutionObject.hotel;
//    NSMutableArray *array = [[hotelSet allObjects] mutableCopy];
//    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"checkin" ascending:YES];
//    NSArray *hotelArray =[array sortedArrayUsingDescriptors:@[sd]];
//    return [self getAlternativeHotel:hotelArray];
    return nil;
}

-(NSMutableArray *)arrangeFlightDataAccToDate:(Solution_Id *)solutionObject
{
//    NSSet *flightSet=solutionObject.flights;
//    NSMutableArray *array = [[flightSet allObjects] mutableCopy];
//    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"departure" ascending:YES];
//    NSArray *flightArray =[array sortedArrayUsingDescriptors:@[sd]];
//    return [self getAlternativeFlights:flightArray];
    return nil;
}
-(NSMutableArray *)sortHotelDataAccToDate:(NSMutableArray *)hotelArray
{
   // NSSet *flightSet=solutionObject.flights;
    if(!hotelArray)
    {
        return nil;
    }
    NSMutableArray *array = hotelArray;
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"checkin" ascending:YES];
    NSArray *hotel =[array sortedArrayUsingDescriptors:@[sd]];
    return [self getAlternativeHotel:hotel];
}
-(NSMutableArray *)sortFlightDataAccToDate:(NSMutableArray *)flightArray
{
    NSMutableArray *array = flightArray;
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"departure" ascending:YES];
    NSArray *flight =[array sortedArrayUsingDescriptors:@[sd]];
    return [self getAlternativeFlights:flight];
}

#pragma mark Get Flight And HotelData
-(NSMutableArray *)getAlternativeFlights:(NSArray *)flightArray
{
    NSMutableArray *alternativeFlight=[[NSMutableArray alloc]init];
    NSMutableArray *notAlternativeFlight=[[NSMutableArray alloc]init];
    NSMutableArray *combineAlternativeFlight=[[NSMutableArray alloc]init];
    for(Flight *flight in flightArray)
    {
        if([[flight isalternative]isEqualToString:@"0"])
        {
            [notAlternativeFlight addObject:flight];
        }
        else
        {
            [alternativeFlight addObject:flight];
        }
    }
    
    [combineAlternativeFlight addObject:notAlternativeFlight];
    [combineAlternativeFlight addObject:alternativeFlight];
    return combineAlternativeFlight;
}

-(NSMutableArray *)getAlternativeHotel:(NSArray *)hotelArray
{
    NSMutableArray *alternativeHotel=[[NSMutableArray alloc]init];
    NSMutableArray *notAlternativeHotel=[[NSMutableArray alloc]init];
    NSMutableArray *combineAlternativeHotel=[[NSMutableArray alloc]init];
    for(Hotel *hotel in hotelArray)
    {
        NSLog(@"hotel isAlternative************=%@",hotel.isalternative);
        if([[hotel isalternative]isEqualToString:@"0"])
        {
            [notAlternativeHotel addObject:hotel];
        }
        else
        {
            [alternativeHotel addObject:hotel];
        }

    }
    [combineAlternativeHotel addObject:notAlternativeHotel];
    [combineAlternativeHotel addObject:alternativeHotel];
    return combineAlternativeHotel;
   // return nil;
}

-(NSMutableArray *)getPassengerDataWithDate:(NSString *)date withHotelArray:(NSArray *)hotelArray withFlightArray:(NSArray *)flightArray
{
    NSMutableArray *getHotelFlightArray=[[NSMutableArray alloc]init];
    NSMutableArray *hotelAccToDate=[[NSMutableArray alloc]init];
    for(Hotel *hotel in hotelArray)
    {
        if([self stringContain:hotel.checkin withDateString:date])
        {
            [hotelAccToDate addObject:hotel];
          
        }
    }
    
     [getHotelFlightArray addObject:[self getFlightArrayByDate:date flightArray:flightArray]];
     [getHotelFlightArray addObject:[self sortHotelDataAccToDate:hotelAccToDate]];
    
     return getHotelFlightArray;
    //return nil;
}

-(NSMutableArray *)getFlightArrayByDate:(NSString *)date flightArray:(NSArray *)flightArray
{
    NSMutableArray *flightAccToDate=[[NSMutableArray alloc]init];
    for(Flight *flight in flightArray)
    {
        if([self stringContain:flight.departure withDateString:date])
        {
            [flightAccToDate addObject:flight];
        }
    }
   
    return [self sortFlightDataAccToDate:flightAccToDate];
  //  return nil;

}

#pragma mark StringContainAnotherString
-(BOOL)stringContain:(NSString *)actualString withDateString:(NSString *)searchString
{
    BOOL isExist=NO;
    if ([actualString rangeOfString:searchString].location == NSNotFound)
    {
        isExist=NO;
    }
    else
    {
        isExist=YES;
    }
    
  return isExist;
}


#pragma mark Arrange Response
-(NSMutableArray *)getresponseArray:(NSMutableArray *)responseArray
{
    NSMutableArray *responseArray1=responseArray;
    for(int i=0;i<responseArray.count;i++)
    {
        Response *response=[responseArray objectAtIndex:i];
       [responseArray1 removeObject:response];
       [responseArray1 insertObject:response atIndex:[[response index]intValue]];
    }
    return responseArray1;
}


#pragma mark PassengerData
-(NSMutableArray *)getPassengerArray:(NSMutableArray *)passengerArray
{
    NSMutableArray *passengerArray1=passengerArray;
    for(int i=0;i<passengerArray.count;i++)
    {
        Passenger *passenger=[passengerArray objectAtIndex:i];
        [passengerArray1 removeObject:passenger];
        [passengerArray1 insertObject:passenger atIndex:[[passenger index]intValue]];
    }
    return passengerArray1;
}
-(NSMutableArray *)getDateArray:(Response *)response
{
    NSMutableArray *dateArray=[[NSMutableArray alloc]init];
    NSString *dateString=nil;
    
    for(Flight *flight in response.flight)
    {
        dateString=[flight.departure substringToIndex:10];//flight.departure;
        [dateArray addObject:dateString];
    }
    NSLog(@"RESPONSE. HOTELIN=%i",response.hotel.count);

    for(Hotel *hotel in response.hotel)
    {
        NSLog(@"hotel address1=%@",hotel.address1);
        dateString=[hotel.checkin substringToIndex:10];//hotel.checkin;
        [dateArray addObject:dateString];
    }
    
    NSArray* uniqueDateValue = [dateArray valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"self"]];
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[uniqueDateValue sortedArrayUsingDescriptors:descriptors];
    return reverseOrder.mutableCopy;
}
-(NSMutableArray *)getPassengerDataAccTODate:(NSMutableArray *)dateArray WithPassengerId:(NSString *)passengerId
{
    return nil;
    
}

#pragma mark colorCode
-(void)setColorCode
{
    colorCodeArray=[[NSMutableArray alloc]init];
    [colorCodeArray addObject:[UIColor colorWithRed:255.0f/255.0f green:127.0f/255.0f blue:80.0f/255.0f alpha:1.0]];
    [colorCodeArray addObject:[UIColor colorWithRed:102.0f/255.0f green:178.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [colorCodeArray addObject:[UIColor colorWithRed:221.0f/255.0f green:160.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
    [colorCodeArray addObject:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0]];
    [colorCodeArray addObject:[UIColor colorWithRed:255.0f/255.0f green:99.0f/255.0f  blue:71.0f/255.0f alpha:1.0]];
    [colorCodeArray addObject:[UIColor colorWithRed:255.0f/255.0f green:182.0f/255.0f  blue:193.0f/255.0f alpha:1.0]];
    
    
    
}
-(NSMutableArray *)getColorCodeArray
{
    if(!colorCodeArray)
    {
        [self setColorCode];
    }
  return colorCodeArray ;
}

-(ContactData*)checkContactEntityExist:(NSString *)entityName passengerName:(NSString *)passengerName
{
     ContactData *contactData=nil;
     NSArray *contactsArray=[self getArrayFromEntity:entityName];
    if(contactsArray)
    {
        
        for(ContactData *contact in contactsArray)
        {
            NSLog(@"value of contact data=%@",contact.name);
            if([contact.name isEqualToString:passengerName])
            {
                contactData=contact;
                break;
            }
        }
    }
    return contactData;
}


-(void)stringContainsWhiteSpace
{
    NSString *foo = @"HALLO WELT";
    NSRange whiteSpaceRange = [foo rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        NSLog(@"Found whitespace");
    }
}
#pragma mark payment info function
-(PaymentInfo *)checkExist
{
    PaymentInfo *paymentInfo=nil;
    NSMutableArray *paymentInfoArray=[[self getArrayFromEntity:AmginePayMentInfo]mutableCopy];
    if(paymentInfoArray)
    {
        if(paymentInfoArray.count>0)
        {
             paymentInfo=[paymentInfoArray objectAtIndex:0];
        }
     
    }
    return paymentInfo;
}

#pragma mark AlertView
- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alertView show];
}


#pragma mark DeleteValueFromCoreData
-(void)deleteHotelData:(Hotel *)hotel
{
   // [getContext deleteObject:hotel];
}

#pragma mark getCountry Code
-(NSMutableArray *)getCountryName
{
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray1= [NSLocale ISOCountryCodes];
    NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
    for (NSString *countryCode in countryArray1)
    {
       NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
       [sortedCountryArray addObject:displayNameString];
    }
    [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
    return sortedCountryArray;
}

#pragma mark convert Html To String
- (NSString *)convertToString:(NSString *)html
{
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(int)getIndexReviewArray:(id)item
{
    int index=0;
    for(id cell in reviewTipDisplayArray)
    {
        if(cell==item)
        {
            return index;
        }
        index++;
    }
    return index;
}

#pragma mark DeleteFunction

-(void)deleteFlight:(Flight *)flight
{
    int  index=0;
    for(Flight *flights in [LiveData getInstance].flightArray)
    {
        if(flights==flight)
        {
            self.deleteIndex=index;
            NSLog(@"index=%i",[Data sharedData].deleteIndex);
            [[[LiveData getInstance]flightArray]removeObject:flights];
            break;
        }
        index++;
    }
}

-(void)deleteHotel:(Hotel *)hotel
{
    int  index=0;
    for(Hotel *hotels in [LiveData getInstance].hotelArray)
    {
        if(hotels==hotel)
        {
             self.deleteIndex=index;
            [[[LiveData getInstance]hotelArray]removeObject:hotels];
            break;
        }
        index++;
    }
}
-(void)removeDropDownObject
{
   for(UIView *view in [Data sharedData].dropDownObjContainer)
   {
       [view removeFromSuperview];
   }
   [[[Data sharedData]dropDownObjContainer] removeAllObjects];
}

-(UIColor *)colorFromHex:(NSString *)hex
{
    unsigned int c;
    if ([hex characterAtIndex:0] == '#') {
        [[NSScanner scannerWithString:[hex substringFromIndex:1]] scanHexInt:&c];
    } else {
        [[NSScanner scannerWithString:hex] scanHexInt:&c];
    }
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0
                           green:((c & 0xff00) >> 8)/255.0
                            blue:(c & 0xff)/255.0 alpha:1.0];
}




-(NSArray *)sortArray:(NSArray *)array keyValue:(NSString *)key
{
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *arr = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:arr];
    return sortedArray;
}

-(NSArray *)getprovincAcctoCountryCode:(NSString *)countryCode withArray:(NSArray *)provinceArray
{
    NSMutableArray *filterProvinceArray=[[NSMutableArray alloc]init];
    for(NSDictionary *dict in provinceArray)
    {
        if([[dict objectForKey:@"countrycode"]isEqualToString:countryCode])
        {
            [filterProvinceArray addObject:dict];
        }
    }
    return filterProvinceArray;
}

#pragma mark String Specific Function

-(NSString *)getStringContainNoWhoteSpace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
#pragma mark Validation Specific Function
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(BOOL)postalZipValidation:(NSString *)countryCode withPostalZipCode:(NSString *)postalZip
{
   if([countryCode isEqualToString:@"CA"])
   {
       NSString *postalRegex = @"^[ABCEGHJKLMNPRSTVXY]{1}\\d{1}[A-Z]{1} *\\d{1}[A-Z]{1}\\d{1}$";
       NSPredicate *postalZipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postalRegex];
        return [postalZipTest evaluateWithObject:postalZip];
   }
   else if([countryCode isEqualToString:@"US"])
       {
       NSString *postalRegex = @"^\\d{5}(-\\d{4})?$";
       NSPredicate *postalZipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postalRegex];
       return [postalZipTest evaluateWithObject:postalZip];
   }
    return 1;
}
-(BOOL)nameValidation:(NSString *)name
{
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    BOOL isValidName=NO;
    if ([name rangeOfCharacterFromSet:numbers].location != NSNotFound)
    {
        isValidName=YES;
    }
    else
    {
        isValidName=NO;
    }
 return isValidName;
}
-(BOOL)stringContainSpecialCharactor:(NSString *)actualString
{
    BOOL isSuccess=NO;
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
    if ([actualString rangeOfCharacterFromSet:characterSet].location != NSNotFound)
    {
        isSuccess=NO;
    }
    else
    {
        isSuccess=YES;
    }

    return isSuccess;
}
-(void)addDeatilView:(BOOL)is_Add view:(id)view
{
    if(is_Add)
    {
        if(!detailViewContainer)
        {
            detailViewContainer=[[NSMutableArray alloc]init];
        }
        [detailViewContainer addObject:view];
    }
    else
    {
        if(detailViewContainer)
        {
            for(id viewToRemove in detailViewContainer)
            {
                [viewToRemove removeFromSuperview];
            }
            [detailViewContainer removeAllObjects];
        }
    }
}
-(BillingInfo *)checkExistanceofBillingInfo
{
    BillingInfo *billingInfo=nil;
    NSArray *billingInfoArray=[self getArrayFromEntity:AmgineBillingInfo];
    if(billingInfoArray.count>0)
    {
        billingInfo=[billingInfoArray objectAtIndex:0];
    }
    return billingInfo;
}


#pragma mark Profile speific Function
-(ProfileInfo *)getExistingProfileInfo:(NSString *)key
{
    ProfileInfo *profileInfo=nil;
    NSArray *profileInfoArray=[self getArrayFromEntity:AmgineProfileInfo];
    for(ProfileInfo *userProfileInfo in profileInfoArray)
    {
        if([userProfileInfo.email_Id isEqualToString:key])
        {
            profileInfo=userProfileInfo;
            break;
        }
    }
    return profileInfo;
}

-(RegisterNewUser *)getExistingUserInfo
{
    RegisterNewUser *registerNewUser=nil;
    NSArray *registerNewUserArray=[self getArrayFromEntity:AmgineRegisterNewUser];
    if(registerNewUserArray.count>0)
    {
        registerNewUser=[registerNewUserArray objectAtIndex:0];
    }
    return registerNewUser;
}
-(void)deleteExistingUserInfo
{
     NSArray *registerNewUserArray=[self getArrayFromEntity:AmgineRegisterNewUser];
    for(RegisterNewUser *registerNewUser in registerNewUserArray)
    {
        [getContext deleteObject:registerNewUser];
    }
     [self writeToDisk];
    userLoginProfileInfo=nil;
}
-(CreateAccountInfo *)checkUserAccountAgainstKey:(NSString *)user_ID WithUserName:(NSString *)userName
{
    CreateAccountInfo *createAccountInfo=nil;
    NSArray *newUSerArray=[self getArrayFromEntity:AmgineCreateAccountInfo];
   if(!userName)
   {
        for(CreateAccountInfo *existingUser in newUSerArray)
        {
            if([[[existingUser userName]lowercaseString] isEqualToString:[user_ID lowercaseString]])
            {
                createAccountInfo=existingUser;
                break;
            }
        }
   }
    else if(userName)
    {
        for(CreateAccountInfo *existingUser in newUSerArray)
        {
            if([[[existingUser firstName]lowercaseString] isEqualToString:[userName lowercaseString]])
            {
                createAccountInfo=existingUser;
                break;
            }
        }

    }
    
    return createAccountInfo;
}
-(void)saveAccountWithPassword:(NSString *)password withServerDictionary:(NSDictionary *)dictionary 
{
    NSLog(@"value of Dictionary=%@",dictionary);
    
    CreateAccountInfo *newUser=[self checkUserAccountAgainstKey:[dictionary objectForKey:@"email"] WithUserName:nil];
    if(!newUser)
    {
         newUser=[NSEntityDescription insertNewObjectForEntityForName:AmgineCreateAccountInfo inManagedObjectContext:[[Data sharedData]getContext]];
    }
  //  Title
    NSLog(@"value of Title=%@",[dictionary objectForKey:@"title"]);
    newUser.title=[dictionary objectForKey:@"title"];
    NSLog(@"value of userName=%@",[dictionary objectForKey:@"email"]);
    newUser.userName=[dictionary objectForKey:@"email"];
    newUser.password=password;
    newUser.confirmPassword=password;
    newUser.firstName=[dictionary objectForKey:@"firstname"];
    newUser.middleName=[dictionary objectForKey:@"middlename"];
    newUser.lastName=[dictionary objectForKey:@"lastname"];
    NSString *dateStr=[[dictionary valueForKey:@"dob"]substringToIndex:10];
    newUser.d_o_b=dateStr;
     NSLog(@"value of homePhone=%@ CellPhone:%@",[dictionary objectForKey:@"homephone"],[dictionary objectForKey:@"cellphone"]);newUser.gender=[dictionary objectForKey:@"gender"];
    NSString *cellPhone=[dictionary objectForKey:@"cellphone"];
    if(cellPhone)
    {
      newUser.cellPhone=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"cellphone"]];
    }
   
    
    newUser.homePhone=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"homephone"]];
    newUser.address1=[dictionary objectForKey:@"addresslineone"];
    newUser.address2=[dictionary objectForKey:@"addresslinetwo"];
    newUser.postalCode=[dictionary objectForKey:@"postalcode"];
    newUser.city=[dictionary objectForKey:@"city"];
    newUser.country=[dictionary objectForKey:@"country"];
    newUser.countryCode=[dictionary objectForKey:@"country"];
    newUser.province=[dictionary objectForKey:@"province"];
    newUser.provinceCode=[dictionary objectForKey:@"province"];
    newUser.cctype=[dictionary objectForKey:@"cctype"];
    newUser.ccFirstName=[dictionary objectForKey:@"ccfirstname"];
    newUser.ccLastName=[dictionary objectForKey:@"cclastname"];
    newUser.gtaUserProfileId=[dictionary objectForKey:@"gtauserprofileid"];
   
    
    // newUser.
    [[Data sharedData]writeToDisk];
}
-(void)userSaveInLocal:(NSString *)username password:(NSString *)password FirstName:(NSString *)firstName token:(NSString *)token
{
    RegisterNewUser *registerNewUser =[[Data sharedData]getExistingUserInfo];
    if(!registerNewUser)
    {
        registerNewUser=[NSEntityDescription insertNewObjectForEntityForName:AmgineRegisterNewUser inManagedObjectContext:[[Data sharedData]getContext]];
    }
    registerNewUser.userName=username;
    registerNewUser.password=password;
    registerNewUser.firstName=firstName;
    registerNewUser.token=token;
    [[Data sharedData]writeToDisk];
//    [dictionary objectForKey:@"firstname"];
//    [[Data sharedData]saveAccountWithPassword:[[allFieldArray objectAtIndex:1]text] withServerDictionary:dictionary];
  //  [Data sharedData].isUserLogin=YES;

}
#pragma mark SaveBookingDictionaryInLocal
-(void)SaveBookingDictionaryInLocal:(NSDictionary *)dictionary
{
    NSMutableArray *bookingDataArray =[[[NSUserDefaults standardUserDefaults]arrayForKey:userLoginProfileInfo.email_Id]mutableCopy];
    if(!bookingDataArray)
    {
        bookingDataArray=[[NSMutableArray alloc]init];
        
    }
    [bookingDataArray addObject:dictionary];
}
-(void)savePreBookingData:(NSDictionary *)dictionary
{
    NSString *solutionId=[LiveData getInstance].solution_ID;
    [[NSUserDefaults standardUserDefaults]setObject:dictionary forKey:solutionId];
    [[NSUserDefaults standardUserDefaults]synchronize];

}


@end
