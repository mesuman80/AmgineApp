//
//  HotelDetailView.h
//  Amgine
//
//  Created by Amgine on 23/06/14.
//   
//

#import <UIKit/UIKit.h>

#import "UrlConnection.h"
#import "BaseDetailView.h"
@class Hotel;
@protocol HotelDetailViewDelegate <NSObject>
-(void)hotelDetailViewDisappear;
@end

@interface HotelDetailView :BaseDetailView<UrlConnectionDelegate,UIAlertViewDelegate>

- (id)initWithFrame:(CGRect)frame withHotelView:(Hotel*)hotel;
-(void)downLoadImage;
-(void)cleanDetailView;
@property id<HotelDetailViewDelegate>delegate;


@end
