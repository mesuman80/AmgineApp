//
//  passengerInfoCell.m
//  Amgine
//
//   on 31/07/14.
//   
//

#import "PassengerInfoCell.h"
#import "Constants.h"
#import "ContactData.h"
#import "Data.h"
#import "Passenger.h"
#import "Hotel.h"
#import "TravelerViewController.h"
#import "LiveData.h"

@implementation PassengerInfoCell
{
    UILabel *passengerName;
    UIImageView *checkImage;
}
@synthesize is_Touch;
@synthesize is_Image;
@synthesize passenger_Name;
@synthesize passengerInfoController;
@synthesize passenger;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        passengerName=[[UILabel alloc]initWithFrame:CGRectZero];
        passengerName.font=[UIFont fontWithName:AmgineFont size:14.0f];
        checkImage=[[UIImageView alloc]initWithFrame:CGRectMake(260,8,30,30)];
        [self.contentView addSubview:passengerName];
        [self.contentView addSubview:checkImage];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)drawTickImage
{
    is_Image=YES;
    is_Touch=YES;
    [self checkImageSetUp:@"tick.png"];
}
-(void)resetImage
{
    is_Image=NO;
    is_Touch=NO;
    [self checkImageSetUp:@"normal.png"];
}

-(ContactData *)checkPassengerInfo:(NSString *)name
{
    return[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:name];
    
}

-(void)configureCell:(NSString *)name
{
    passenger_Name=name;
    passengerName.frame=CGRectMake(10,4,100,50);
    passengerName.text=name;
    if([self checkPassengerInfo:name])
    {
        if(!is_Image)
        {
            [self drawTickImage];
        }
        
    }
    else
    {
        [self checkImageSetUp:@"normal.png"];
    }
}
-(void)checkImageSetUp:(NSString *)imageStr
{
    [checkImage setImage:nil];
    [checkImage setImage:[UIImage imageNamed:imageStr]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point=[[touches anyObject]locationInView:self];
    if(CGRectContainsPoint(checkImage.frame, point))
    {
        if(is_Image)
        {
          //  ContactData *contactData =[self checkPassengerInfo:passenger_Name];
//            [[[Data sharedData]getContext]deleteObject:contactData];
//            [[Data sharedData]writeToDisk];
            [self resetImage];
        }
        else
        {
            [self gotoNextScreen];
        }
    }
    else
    {
        [self gotoNextScreen];
    }
    
}
-(void)gotoNextScreen
{
    BOOL isExist=NO;
    for(Hotel *hotel in [[LiveData getInstance]hotelArray])
    {
        if([hotel.isalternative isEqualToString:@"0"] && [passenger.paxguid isEqualToString:hotel.paxguid])
        {
            isExist=YES;
            break;
        }
    }
    [LiveData getInstance].isHotel=isExist;
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController=[storyBoard instantiateViewControllerWithIdentifier:@"Amgine_View_Controller_Traveler"];
    TravelerViewController *travellerViewController=[navigationController.viewControllers objectAtIndex:0];
    travellerViewController.passengerInfoCell=self;
    travellerViewController.passengerName=passenger_Name;
    [passengerInfoController presentViewController:navigationController animated:YES completion:nil];
    

}


@end
