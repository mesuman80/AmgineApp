//
//  FlightDetailView.h
//  Amgine
//
//  Created by Amgine on 23/06/14.
//   
//

#import <UIKit/UIKit.h>
#import "BaseDetailView.h"
@class Flight;

@protocol FlightDetailDelegate <NSObject>
-(void)flightDetailViewDisappear;
@end

@interface FlightDetailView : BaseDetailView
- (id)initWithFrame:(CGRect)frame WithFlightView:(Flight *)flightView;

@property id<FlightDetailDelegate>delegate;
-(void)drawUI:(Flight *)flightView;
@end
