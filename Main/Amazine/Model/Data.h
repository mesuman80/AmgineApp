//
//  Data.h
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Response.h"
#import "Solution_Id.h"
#import "PaymentInfo.h"


@class ContactData;
@class ProfileInfo;
@class RegisterNewUser;
@class BillingInfo;
@class CreateAccountInfo;

@interface Data : NSObject

+(Data *)sharedData;
-(AppDelegate *)appDelegateInstance;

-(void)addBorderToButton:(UIButton *)button;
-(void)addBorderToTextView:(UITextView *)textView;

-(NSArray*)getArrayFromEntity:(NSString *)entityName;
-(void)saveSolutionEntity:(NSString *)solution_id withResponse:(NSArray *)responseArray;
-(NSSet *)getHotelArray:(NSMutableArray *)fetchObject;
-(NSSet *)getFlightArray:(NSMutableArray *)fetchObject;
-(NSSet *)getFlightLegArray:(NSMutableArray *)fetchObject;
-(Response *)getResponse:(NSMutableArray *)fetchObject;

-(Solution_Id *)getSolutionId:(NSString *)soloutionId fromArray:(NSMutableArray *)arr;

-(NSMutableArray*)dataByID:(NSString *)passenger_id withDateArray:(NSMutableArray *)dateArray WithResponse:(Response *)response;
-(NSMutableArray*)flightsByID:(NSString *)passenger_id withSolution:(Solution_Id *)solutionObject WithResponse:(Response *)response;

-(NSString *)getDateFormat:(NSString *)dateFormat withDateString:(NSString *)dateStr dateFormat:(NSString *)format;

-(NSMutableArray *)arrangeHotelDataAccToDate:(Solution_Id *)solutionObject;
-(NSMutableArray *)arrangeFlightDataAccToDate:(Solution_Id *)solutionObject;

-(NSMutableArray *)getPassengerDataWithDate:(NSString *)date withHotelArray:(NSArray *)hotelArray withFlightArray:(NSArray *)flightArray;
-(void )getAllDataArrayWithPassengerArray:(NSArray *)passengerArray WithResponse:(Response *)response WithDateArray:(NSArray *)dateArray;

-(NSMutableArray *)getAllHotelArrayWithPassengerArray:(NSMutableArray *)passengerArray WithResponse:(Response *)response;
-(NSMutableArray *)getDateArray:(Response *)response;
-(void)saveContactData:(NSMutableDictionary *)contactsDictionary name:(NSString *)name;
-(void)setColorCode;
-(NSMutableArray *)getColorCodeArray;
-(ContactData*)checkContactEntityExist:(NSString *)entityName passengerName:(NSString *)passengerName;
-(void)addBorderToUiView:(UIView *)view;
-(NSString *)getDateStr:(NSDate *)date format:(NSString *)dateFormat;

-(void)addImageBorder:(UIImageView *)view;
-(NSMutableArray *)userExist;
-(PaymentInfo *)checkExist;

-(BOOL)stringContain:(NSString *)actualString withDateString:(NSString *)searchString;
- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title;
-(NSMutableArray *)getCountryName;
-(NSString *)convertToString:(NSString *)html;



-(int)getIndexReviewArray:(id)item;
-(void)deleteFlight:(Flight *)flight;
-(void)deleteHotel:(Hotel *)hotel;
-(void)removeDropDownObject;
-(UIColor *)colorFromHex:(NSString *)hex;
-(void)writeToDisk;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
-(NSArray *)sortArray:(NSArray *)array keyValue:(NSString *)key;
-(NSString *)getStringContainNoWhoteSpace:(NSString *)string;
-(NSArray *)getprovincAcctoCountryCode:(NSString *)countryCode withArray:(NSArray *)provinceArray;
-(BOOL)postalZipValidation:(NSString *)countryCode withPostalZipCode:(NSString *)postalZip;
-(void)SaveBookingDictionaryInLocal:(NSDictionary *)dictionary;
-(BOOL)stringContainSpecialCharactor:(NSString *)actualString;

-(BillingInfo *)checkExistanceofBillingInfo;
-(void)savePreBookingData:(NSDictionary *)dictionary;
//**********************ProfileInfoFunction****************************************
-(ProfileInfo *)getExistingProfileInfo:(NSString *)key;
-(RegisterNewUser *)getExistingUserInfo;
-(void)deleteExistingUserInfo;
-(CreateAccountInfo *)checkUserAccountAgainstKey:(NSString *)user_ID WithUserName:(NSString *)userName;
-(void)saveAccountWithPassword:(NSString *)password withServerDictionary:(NSDictionary *)dictionary;

-(void)userSaveInLocal:(NSString *)username password:(NSString *)password FirstName:(NSString *)firstName token:(NSString *)token;
-(BOOL)nameValidation:(NSString *)name;



@property(nonatomic,strong)NSManagedObjectContext *getContext;
@property(nonatomic,strong)NSMutableArray *colorCodeArray;
@property(nonatomic,strong)NSMutableArray *viewColorArray;
@property(nonatomic,strong)NSMutableArray *viewCenterValue;
@property(nonatomic,strong)NSMutableArray *buttonDisplayName;
@property (nonatomic,strong)UIView *lastDeleteCell;
@property(nonatomic,strong)UIColor *buttonColor;
@property NSMutableArray *dropDownObjContainer;
@property NSMutableArray *borderViewArray;
@property UIImageView *undoImage;
@property int deleteIndex;
@property NSString *passengerScreen;
@property NSMutableArray *reviewTipDisplayArray;
@property int selectedPassengerIndex;
@property int selectedCellIndex;;
@property NSMutableArray *colorpeletteCode;
@property NSArray *countryArray;
@property ProfileInfo *userLoginProfileInfo;
@property BOOL isUserLogin;
@property NSMutableArray *detailViewContainer;
-(void)addDeatilView:(BOOL)is_Add view:(id)view;


@end
Data *dataInstance;
