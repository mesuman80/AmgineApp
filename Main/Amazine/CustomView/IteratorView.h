//
//  IteratorView.h
//  Amazine
//
//  Created by Amgine on 14/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Solution_Id.h"
#import "HotelViewCell.h"
#import "FlightViewCell.h"

@interface IteratorView:UIView<UIScrollViewDelegate,HotelCellDelegate,FlightCellDelegate>
@property NSArray *passengerIdArray;
@property NSMutableArray *responseArray;
@property Solution_Id *solution_id;

@property NSMutableArray *colorCodeArray;
@property int iteratorIndex;
@property UIImageView *imageView;

//@property int displaceMent;
-(void)flightHotelData:(int)index;
-(void)drawAllPassengerData;
- (id)initWithFrame:(CGRect)frame WithRootViewController:(UIViewController *)rootController;

@end
