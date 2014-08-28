//
//  FlightDetailViewController.m
//  Amgine
//
//  Created by Amgine on 23/06/14.
//   
//

#import "FlightDetailViewController.h"
#import "Data.h"

#import "Constants.h"

@interface FlightDetailViewController ()

@end

@implementation FlightDetailViewController
{
    NSMutableArray *labelDisplayArray;
    float factor;
   // NSMutableArray
}
@synthesize flight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    factor=self.view.frame.size.height/568.0;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UINavigationBar *navbar= self.navigationController.navigationBar;
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnBackButton:)];
    self.navigationItem.leftBarButtonItem=item;
   // [self drawFlightData];
    
    labelDisplayArray=[[NSMutableArray alloc]init];
    
    NSString *destinationStr=[NSString stringWithFormat:@"%@-%@",flight.origin,flight.destination];
    NSString *costString=[NSString stringWithFormat:@"$ %@",flight.cost];
    
    NSMutableDictionary *flightCost=[[NSMutableDictionary alloc]init];
    [flightCost setObject:destinationStr forKey:@"labelDisplay"];
    [flightCost setObject:costString forKey:@"labelValue"];
    [labelDisplayArray addObject:flightCost];
    
     NSMutableDictionary *flightNumber=[[NSMutableDictionary alloc]init];
    [flightNumber setObject:@"FlightNumber" forKey:@"labelDisplay"];
    [flightNumber setObject:flight.flightnumber forKey:@"labelValue"];
    [labelDisplayArray addObject:flightNumber];
    
    NSMutableDictionary *flightTime=[[NSMutableDictionary alloc]init];
    [flightTime setObject:@"FlightTime" forKey:@"labelDisplay"];
    [flightTime setObject:flight.flighttime forKey:@"labelValue"];
     [labelDisplayArray addObject:flightTime];
    
    
    NSMutableDictionary *departure=[[NSMutableDictionary alloc]init];
    [departure setObject:@"Departure" forKey:@"labelDisplay"];
    [departure setObject:flight.departure forKey:@"labelValue"];
     [labelDisplayArray addObject:departure];
    
    NSMutableDictionary *arrival=[[NSMutableDictionary alloc]init];
    [arrival setObject:@"Arrival" forKey:@"labelDisplay"];
    [arrival setObject:flight.arrival forKey:@"labelValue"];
     [labelDisplayArray addObject:arrival];
    
    NSMutableDictionary *origin=[[NSMutableDictionary alloc]init];
    [origin setObject:@"Origin" forKey:@"labelDisplay"];
    [origin setObject:flight.origin forKey:@"labelValue"];
     [labelDisplayArray addObject:origin];
    
    NSMutableDictionary *destination=[[NSMutableDictionary alloc]init];
    [destination setObject:@"Destination" forKey:@"labelDisplay"];
    [destination setObject:flight.destination forKey:@"labelValue"];
    [labelDisplayArray addObject:destination];
    
    
    
    [self drawFlightDetail:labelDisplayArray];
    
    //[self DrawAlterNativeFlightButton];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma MarkDrawingFunction
-(void)drawFlightData
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,factor*48,215,30)];
    NSString *destination=[NSString stringWithFormat:@"%@-%@",flight.origin,flight.destination];
    [label setText:destination];
    label.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
    [self.view addSubview:label];
    
    UILabel *costLabel=[[UILabel alloc]init];
    NSString *costString=[NSString stringWithFormat:@"$ %@",flight.cost];
    costLabel.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
    CGSize labelValueSize = [costString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0*factor]}];
    costLabel.frame=CGRectMake(320-labelValueSize.width-10,factor*48, labelValueSize.width, 30);
    costLabel.text=costString;
    [self.view addSubview:costLabel];
}

-(void)DrawAlterNativeFlightButton
{
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"AlternativeFlights" forState:UIControlStateNormal];
//    button.frame=CGRectMake(0, 0, 30, 30);
//    [button setBackgroundColor:[UIColor clearColor]];
//    button.center=CGPointMake(screenWidth*.80f, screenHeight*.20f);
//    [button addTarget:self action:@selector(alterNativeFlights:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    [[Data sharedData]addBorderToButton:button];

}

-(void)alterNativeFlights:(id)sender
{
    
}
#pragma mark TouchOnBackButton
-(void)touchOnBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark DrawMethods
-(void)drawFlightDetail:(NSMutableArray*)flightData
{
    float yy=58.0f*factor;
    for(NSDictionary * dictionary in flightData)
    {
        UILabel *labelName=[[UILabel alloc]init];
        NSString *labelText=[dictionary objectForKey:@"labelDisplay"];
        labelName.text=labelText;
        labelName.font=[UIFont fontWithName:AmgineFont size:16.0*factor];
        [labelName setBackgroundColor:[UIColor clearColor]];
        CGSize labelValueSize = [labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:16.0*factor]}];
        labelName.frame=CGRectMake(10,yy,labelValueSize.width,labelValueSize.height);
        [self.view addSubview:labelName];
        
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
        [label setBackgroundColor:[UIColor clearColor]];
        NSString *flightNumber=[dictionary objectForKey:@"labelValue"];
        CGSize labelValueSize1 = [flightNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0*factor]}];
        label.text=flightNumber;
        label.frame=CGRectMake(125, yy, labelValueSize1.width, labelValueSize1.height);
        [self.view addSubview:label];
        yy+=37.0f*factor;

    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
