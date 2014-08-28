//
//  BookingConfirmationCell.m
//  Amgine
//


#import "BookingConfirmationCell.h"
#import "LiveData.h"
#import "Data.h"
#import "Constants.h"
#import "LineView.h"
#define AmgineRatngImage @"AmgineRatingImage"

@implementation BookingConfirmationCell
{
    UIView *ratingView;
    UrlConnection *urlConnection;
}
@synthesize responseDictionary;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark draw Function
-(void)configureBookingFlightCell
{
    // UIView *flightImageContainerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    UIImageView *flightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flightBookImage@2x"]];
    flightImage.frame=CGRectMake(0, 0,70, 70);
   // [flightImageContainerView addSubview:flightImage];
       [self addSubview:flightImage];
    
    UILabel *confirmationLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    NSString *bookingreferenceid=[responseDictionary objectForKey:@"bookingreferenceid"];
    NSString *confirmationStr=[NSString stringWithFormat:@"Confirmation #%@",bookingreferenceid];
    CGSize confirmatonStrSize = [confirmationStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0f]}];
    confirmationLabel.textColor=[UIColor blackColor];
  //  [confirmationLabel setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0/255.0f blue:224.0f/255.0f alpha:1.0f]];
    confirmationLabel.font=[UIFont fontWithName:AmgineFont size:14.0];
    confirmationLabel.text=confirmationStr;
    confirmationLabel.frame=CGRectMake(flightImage.frame.size.width+4,4,confirmatonStrSize.width, confirmatonStrSize.height);
    [self addSubview:confirmationLabel];
    
    NSDictionary *flightSegmentDict=[responseDictionary objectForKey:@"flightsegments"];
    float yy=confirmationLabel.frame.size.height+6;
     CGRect rect=CGRectZero;
    int index=0;
    for(NSDictionary *flightSegmentDictionary in flightSegmentDict)
    {
        rect=CGRectZero;
        LineView *lineView=[[LineView alloc]initWithFrame:CGRectMake(flightImage.frame.size.width+2,yy,320,2)];
        [lineView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
        [self addSubview:lineView];
        rect=lineView.frame;
        yy+=lineView.frame.size.height+4;
        
        UIView *flightSegmentView=[[UIView alloc]initWithFrame:CGRectZero];
        
        UILabel *flightCarrierNumberLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        flightCarrierNumberLabel.text=[NSString stringWithFormat:@"%@ %@ %@",[flightSegmentDictionary objectForKey:@"carrier"],@"Flight",[flightSegmentDictionary objectForKey:@"flightnumber"]];
       flightCarrierNumberLabel.textColor=[UIColor blackColor];
       flightCarrierNumberLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
       [flightCarrierNumberLabel setBackgroundColor:[UIColor clearColor]];
       //[self addSubview:flightCarrierNumberLabel];
       CGSize size = [flightCarrierNumberLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
       flightCarrierNumberLabel.frame=CGRectMake(/*flightImage.frame.size.width+4*/ 2,0, size.width, size.height);
       rect=flightCarrierNumberLabel.frame;
       yy+=flightCarrierNumberLabel.frame.size.height+4;
        
        [flightSegmentView addSubview:flightCarrierNumberLabel];
        
        NSString *departureDate=[flightSegmentDictionary objectForKey:@"departuredatetime"];
        NSString *dateStr=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:departureDate dateFormat:@"MMM dd"];
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [dateLabel setText:dateStr];
        [dateLabel setFont:[UIFont fontWithName:AmgineFont size:12.0]];
         CGSize dateLableSize = [dateLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
         dateLabel.frame=CGRectMake(/*flightImage.frame.size.width+4*/2,rect.origin.y+rect.size.height+4, dateLableSize.width, dateLableSize.height);
        //[self addSubview:dateLabel];
        rect=dateLabel.frame;
        yy+=dateLabel.frame.size.height+4;
        
        [flightSegmentView addSubview:dateLabel];
        
        
        
        
        UILabel *flightSegment=[[UILabel alloc]initWithFrame:CGRectZero];
        flightSegment.textColor=[UIColor blackColor];
        flightSegment.font=[UIFont fontWithName:AmgineFont size:12.0];
        NSString *departureAirPort=[flightSegmentDictionary objectForKey:@"departuredatetime"];
        NSString *departureTimeStr=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:departureAirPort dateFormat:@"hh:mm a"];
        
        NSString *arrivaldatetime=[flightSegmentDictionary objectForKey:@"arrivaldatetime"];
        NSString *arrivaldatetimeStr=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:arrivaldatetime dateFormat:@"hh:mm a"];
        NSString *str=[NSString stringWithFormat:@"%@ %@ -> %@ %@",[flightSegmentDictionary objectForKey:@"departureairport"],departureTimeStr,[flightSegmentDictionary objectForKey:@"arrivalairport"],arrivaldatetimeStr];
        [flightSegment setText:str];
        CGSize flightSegmentSize = [flightSegment.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
        flightSegment.frame=CGRectMake(/*flightImage.frame.size.width+4*/2,rect.origin.y+rect.size.height+4, flightSegmentSize.width, flightSegmentSize.height);
         if(index%2==0)
         {
             [flightSegmentView setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:229.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
         }
         else
         {
            [flightSegmentView setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
         }
         rect=flightSegment.frame;
       // yy+=flightSegment.frame.size.height+4;
        [flightSegmentView addSubview:flightSegment];
        flightSegmentView.frame=CGRectMake(flightImage.frame.size.width+2,lineView.frame.origin.y+lineView.frame.size.height,320-flightImage.frame.size.width,flightSegment.frame.origin.y+flightSegment.frame.size.height+4);
        [self addSubview:flightSegmentView];
        rect=flightSegmentView.frame;
        
        
        LineView *lineView1=[[LineView alloc]initWithFrame:CGRectMake(flightImage.frame.size.width+2,flightSegmentView.frame.size.height,320,2)];
        [lineView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
        [self addSubview:lineView1];
         rect=lineView1.frame;
         yy+=lineView1.frame.size.height+12;
        index++;
    }
    [self setFrame:CGRectMake(0, self.frame.origin.y,self.frame.size.width, yy)];
    [flightImage setCenter:CGPointMake(flightImage.center.x ,yy/2)];
    [self setBackgroundColor:[UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f]];

    //[self setBackgroundColor:[UIColor redColor]];
    NSLog(@"frame=%f,%f , %f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,yy);
    
}

-(void)configureBookingHotelCell
{
    UIImageView *hotelImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel1.jpg"]];
    hotelImage.frame=CGRectMake(0, 0,70,70);
    [self addSubview:hotelImage];
   // [self drawView];
   // [self openUrl:[responseDictionary objectForKey:@"tripAdvisorRatingUrl"] withObjType:AmgineRatngImage withRootView:ratingView];
    
    NSMutableArray *hotelDisplayArray=[[NSMutableArray alloc]init];
    NSString *hotelNameWithCity=[NSString stringWithFormat:@"%@ ,%@",[responseDictionary objectForKey:@"hotelName"],[responseDictionary objectForKey:@"hotelCity"]];
    
    NSMutableDictionary *hotelnameDict=[[NSMutableDictionary alloc]init];
    [hotelnameDict setObject:hotelNameWithCity forKey:@"labelValue"];
    [hotelnameDict setObject:@"HotelName" forKey:@"labelStr"];
    [hotelDisplayArray addObject:hotelnameDict];
    
    NSMutableDictionary *roomDescriptionDict=[[NSMutableDictionary alloc]init];
    [roomDescriptionDict setObject:[responseDictionary objectForKey:@"roomDescription"] forKey:@"labelValue"];
    [roomDescriptionDict setObject:@"Room Description" forKey:@"labelStr"];
    [hotelDisplayArray addObject:roomDescriptionDict];
    
     NSMutableDictionary *ratingDict=[[NSMutableDictionary alloc]init];
    [ratingDict setObject:[responseDictionary objectForKey:@"tripAdvisorRatingUrl"] forKey:@"labelValue"];
    [ratingDict setObject:@"Rating" forKey:@"labelStr"];
    [hotelDisplayArray addObject:ratingDict];
    int index=0;
    float yy=0.0f;
     //yy+=frame.size.height+8;
    
    for(NSDictionary *dict in hotelDisplayArray)
    {
        if(index==2)
        {
             [self drawView:CGRectMake(hotelImage.frame.size.width+4,yy+4,145, 30)];
             [self openUrl:[responseDictionary objectForKey:@"tripAdvisorRatingUrl"] withObjType:AmgineRatngImage withRootView:ratingView];
             yy+=ratingView.frame.size.height+4;
        }
        else
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
            NSString *str=[dict objectForKey:@"labelValue"];
            label.text=str;
            label.textColor=[UIColor blackColor];
            label.font=[UIFont fontWithName:AmgineFont size:14.0];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=0;
            CGSize  textSize = {246, 10000.0};
            CGRect frame = [str boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0f]}
                                             context:nil];
            label.frame=CGRectMake(hotelImage.frame.size.width+4,yy,frame.size.width,frame.size.height);
            [self addSubview:label];
            NSLog(@"value of y=(%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
            yy+=frame.size.height+4;
        }
        index++;
        
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, yy+4)];
     [self setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
    
    [hotelImage setCenter:CGPointMake(hotelImage.center.x ,self.center.y)];
}
-(void)drawView:(CGRect)rectangle
{
    ratingView=[[UIView alloc]initWithFrame:CGRectMake(rectangle.origin.x, rectangle.origin.y,rectangle.size.width,rectangle.size.height)];
    [[Data sharedData]addBorderToUiView:ratingView];
    [self addSubview:ratingView];
}
-(void)drawImageView:(NSData *)imageData
{
     UIImageView *hotelImage=[[UIImageView alloc]initWithImage:[UIImage imageWithData:imageData]];
    hotelImage.frame=CGRectMake(0, 0, ratingView.frame.size.width-2, ratingView.frame.size.height);
    [ratingView addSubview:hotelImage];

}

#pragma mark urlConnectionDelegate
-(void)openUrl:(NSString *)urlToOpen withObjType:(NSString *)objectType withRootView:(UIView *)view
{
    if(!urlConnection)
    {
        urlConnection=[[UrlConnection alloc]init];
        urlConnection.delegate=self;
        urlConnection.serviceName=objectType;
        urlConnection.activity= [self showActivityIndicator:view];
        [urlConnection openUrl:urlToOpen];

    }
    else
    {
         urlConnection.delegate=self;
        [urlConnection openUrl:urlToOpen];
    }
    
}

-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection
{
    [self removeActivityIndicator:connection];
    [self drawImageView:data];
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self openUrl:[responseDictionary objectForKey:@"tripAdvisorRatingUrl"] withObjType:AmgineRatngImage withRootView:ratingView];
}
#pragma mark activity Indicator Specific Function
-(UIActivityIndicatorView *)showActivityIndicator:(UIView *)view
{
    UIActivityIndicatorView * activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center=CGPointMake(view.center.x-20,16);
    [view addSubview:activity];
    [activity startAnimating];
    return activity;
}

-(void)removeActivityIndicator:(UrlConnection *)connection
{
    [connection.activity stopAnimating];
    [connection.activity removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
