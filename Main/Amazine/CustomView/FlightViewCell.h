//
//  FlightViewCell.h
//  Amazine
//
//  Created by Amgine on 14/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"
#import "IteratorViewController.h"
#import "FlightDetailView.h"
#import "UrlConnection.h"


@protocol FlightCellDelegate <NSObject>
-(void)returnDelegate:(NSString *)cost;
-(void)deleteDelegate:(NSString *)cost view:(UIView *)cell;
-(void)undoOption:(UIView *)cell withCost:(NSString *)cost;
-(void)touchStart;
-(void)gotoNextScreen:(NSString *)string withRootView:(UIView *)cell withPoint:(CGPoint)point;
@end

@interface FlightViewCell : UIView<FlightDetailDelegate,UrlConnectionDelegate>
-(void)drawRectangle:(CGRect)rectanglRect Color:(UIColor *)color;
-(void)drawOrigin_DestinationPlace:(NSString *)value;
-(void)drawCost:(NSString *)cost;
-(void)drawImage;
-(void)drawDate:(NSString *)date;
-(void)addBorder;
-(void)removeBorder;

@property int objectId;
@property CGRect rectangleRect;
@property Flight *flights;
@property NSArray *flightArray;
@property id<FlightCellDelegate>delegate;
@property IteratorViewController *rootViewController;
@property NSString *passengerId;

@property NSArray *colorPelette;
-(void)drawalternativeDetail:(BOOL)isUpdate;
-(void)drawFlightNumber:(NSString *)flightNumber;
-(void)updateView:(Flight *)updateFlight animationNeed:(BOOL)isNeed;

@end
