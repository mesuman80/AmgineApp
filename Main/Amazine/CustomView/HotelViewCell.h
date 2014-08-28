//
//  RectangleView.h
//  Amazine
//
//  Created by Amgine on 13/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hotel.h"
#import "IteratorViewController.h"
#import "HotelDetailView.h"
#import "UrlConnection.h"


@protocol HotelCellDelegate <NSObject>
-(void)returnDelegate:(NSString *)cost;
-(void)deleteDelegate:(NSString *)cost view:(UIView *)cell;
-(void)undoOption:(UIView *)cell withCost:(NSString *)cost;
-(void)touchStart;
-(void)gotoNextScreen:(NSString *)string withRootView:(UIView *)cell;
@end

@interface HotelViewCell:UIView<HotelDetailViewDelegate,UrlConnectionDelegate>
@property int objectId;
@property CGRect rectangleRect;
@property Hotel *hotels;
@property NSArray *hotelArray;
@property id<HotelCellDelegate>delegate;
@property IteratorViewController *rootViewController;
@property NSString *passengerId;

@property NSArray *colorPelette;

-(void)drawRectangle:(CGRect)rectanglRect Color:(UIColor *)color;
-(void)drawHotelName:(NSString *)value;
-(void)drawCost:(NSString *)cost;
-(void)drawDate:(NSString *)date;
-(void)drawImage;
-(void)addBorder;
-(void)removeBorder;
-(void)drawalternativeDetail:(BOOL)isUpdate;
-(void)updateView:(Hotel *)updateHotel animationNeed:(BOOL)isNeed;



@end
