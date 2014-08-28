//
//  AlternativeView.h
//  Amgine
//
//  Created by Amgine on 17/07/14.
//   
//

#import <UIKit/UIKit.h>
#import "HotelDetailView.h"
#import "FlightDetailView.h"
#import "UrlConnection.h"


@protocol AlternativeViewDelegate <NSObject>
-(void)returnFromAlternativeView:(UIView *)item view:(UIView *)view;
@end

@interface AlternativeView : UIView<FlightDetailDelegate,HotelDetailViewDelegate,UrlConnectionDelegate>
-(void)labelDisplay:(NSString *)displayString;
-(void)costDisplay:(NSString *)displayString;
-(void)drawIcon;
-(void)updateAlternativeFlightView:(Flight *)flight;
-(void)updateAlternativeHotelView:(Hotel *)hotel;

@property id<AlternativeViewDelegate>delegate;
@property UIView *view;
@property int indexValue;
@property UIViewController *rootViewCtrl;
@property UIView *rootCell;
@end
