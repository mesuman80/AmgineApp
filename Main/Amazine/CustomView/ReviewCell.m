//
//  ReviewCell.m
//  Amgine
//
//  Created by Amgine on 22/07/14.
//   
//

#import "ReviewCell.h"
#import "Hotel.h"
#import "Flight.h"
#import "Constants.h"
#import "Passenger.h"
#import "Data.h"
#import "LiveData.h"

@implementation ReviewCell
{
    UIImageView *imageView;
    UILabel *costLabelValue;
    UILabel *displayLabel;
    UILabel *flightNumberLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,4, 20, 20)];
        [self.contentView addSubview:imageView];
        
        costLabelValue=[[UILabel alloc]initWithFrame:CGRectMake(240,4,70,20)];
        costLabelValue.textColor=[UIColor whiteColor];
        costLabelValue.font=[UIFont fontWithName:AmgineFont size:13.0];
        [self.contentView addSubview:costLabelValue];
        
        displayLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        displayLabel.textColor=[UIColor whiteColor];
        displayLabel.font=[UIFont fontWithName:AmgineFont size:13.0];
        [self.contentView addSubview:displayLabel];
        
        flightNumberLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:flightNumberLabel];

        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)configureCell:(UIView *)classView
{
    NSString *costValue=nil;
    NSString *imageName=nil;
    NSString *displayString=nil;
    CGRect displayRect=CGRectZero;
    
   if([classView isKindOfClass:[Flight class]])
   {
       costValue=((Flight *)classView).cost;
       imageName=@"Flight";
       displayString=[NSString stringWithFormat:@"%@-%@",((Flight *)classView).origin,((Flight *)classView).destination];
       displayRect=CGRectMake(30,4,120,20);
       displayLabel.frame=displayRect;
       displayLabel.text=displayString;
       [self getColorIndexAccToPassenger:((Flight *)classView).paxguid];
       [self drawFlightNumber:(Flight *)classView];
       

       
   }
    else if ([classView isKindOfClass:[Hotel class]])
    {
        costValue=((Hotel *)classView).cost;
        imageName=@"hotel";
        displayString=((Hotel *)classView).hotelname;
        displayRect=CGRectMake(30,4,120,20);
        displayLabel.frame=displayRect;
        displayLabel.text=displayString;
        displayLabel.adjustsFontSizeToFitWidth=NO;
        displayLabel.lineBreakMode=NSLineBreakByWordWrapping;
        displayLabel.numberOfLines=0;
        [displayLabel sizeToFit];
        NSLog(@"VALUE OF NUMBE OF LINE =%i",displayLabel.numberOfLines);
        [self getColorIndexAccToPassenger:((Hotel *)classView).paxguid];
    }
    
    
     costLabelValue.text=[NSString stringWithFormat:@"$%0.02f",costValue.floatValue];
     [imageView setImage:[UIImage imageNamed:imageName]];
}

-(void)drawFlightNumber:(Flight *)flight
{
   
    flightNumberLabel.text=[NSString stringWithFormat:@"%@ %@",flight.carrier,flight.flightnumber];
    flightNumberLabel.textColor=[UIColor whiteColor];
    flightNumberLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
    [flightNumberLabel setBackgroundColor:[UIColor clearColor]];
    CGSize size = [flightNumberLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
    flightNumberLabel.frame=CGRectMake(31,22, size.width, size.height);
    //[flightNumberLabel setBackgroundColor:[UIColor redColor]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(int)getColorIndexAccToPassenger:(NSString *)passenger_Id
{
    int index=0;
    for(Passenger *passenger in [LiveData getInstance].passengerArray)
    {
        if([passenger.paxguid isEqualToString:passenger_Id])
        {
            [self setBackGroundClr:[[[Data sharedData]colorCodeArray]objectAtIndex:index]];
            break;
        }
        index++;
    }
    return index;
}
-(void)setBackGroundClr:(UIColor *)color
{
    [self setBackgroundColor:color];
}

@end
