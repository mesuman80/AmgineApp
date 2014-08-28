//
//  ReviewForBookingCell.m
//  Amgine
//
//   on 30/07/14.
//   
//

#import "ReviewForBookingCell.h"
#import "Data.h"
#import "Constants.h"
#import "Hotel.h"
#import "Flight.h"
#import "Passenger.h"
#import "LiveData.h"

@implementation ReviewForBookingCell
{
    UIImageView *imageView;
    UILabel *costLabelValue;
    UILabel *displayLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
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
    
    
   // CGSize size = [displayString sizeWithAttributes:
                //   @{NSFontAttributeName:
                    //     [UIFont systemFontOfSize:17.0f]}];
    
    costLabelValue.text=[NSString stringWithFormat:@"$%0.02f",costValue.floatValue];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [self drawApplyDrawButton];
    
}

-(void)drawApplyDrawButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(self.frame.size.width-100, self.frame.origin.y + 25, 100, 30);
    [button setTitle:@"Apply" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(applyButtonPress:) forControlEvents:UIControlEventTouchUpInside];
     button.backgroundColor= [UIColor clearColor];
    [self.contentView addSubview:button];
}
-(void)applyButtonPress:(id)sender
{
    NSLog(@"Touches on apply");
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
