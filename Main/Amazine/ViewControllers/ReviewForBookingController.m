//
//  ReviewForBooking.m
//  Amgine
//
//   on 30/07/14.
//   
//

#import "ReviewForBookingController.h"
#import "Data.h"
#import "ReviewForBookingCell.h"
#import "ScreenInfo.h"

@interface ReviewForBookingController ()

@end

@implementation ReviewForBookingController
{
    UITableView *dynamicTableView;
    NSArray *displayItem;
    float screenHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark ViewLifeCycleFunction
- (void)viewDidLoad
{
    [super viewDidLoad];
    screenHeight=[ScreenInfo getScreenHeight];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    displayItem=[[Data sharedData]reviewTipDisplayArray];
    [self addCustomTableView];
    [self drawSaveButton];
    [self drawBookButton];
    // Do any additional setup after loading the view.
}

#pragma mark ButtonDrawingFunction
-(void)drawSaveButton
{
    UIButton *saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame=CGRectMake(20,screenHeight*.90f,80, 45);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    //[editButton setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [saveButton setTitleColor:[[Data sharedData]buttonColor] forState:UIControlStateNormal];
    saveButton.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin;
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

-(void)drawBookButton
{
    UIButton *bookButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bookButton.frame=CGRectMake(220,screenHeight*.90f,80, 45);
    [bookButton setTitle:@"Book" forState:UIControlStateNormal];
    [bookButton setTitleColor:[[Data sharedData]buttonColor] forState:UIControlStateNormal];
    bookButton.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin;
    [bookButton addTarget:self action:@selector(bookButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookButton];
}

-(void)saveButtonClick:(id)sender
{
    NSLog(@"Save Button Click");
}
-(void)bookButtonClick:(id)sener
{
    NSLog(@"Book Button click");
}
#pragma mark TableViewSpecificFunction
-(void)addCustomTableView
{
    dynamicTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,320,screenHeight*.60f) style:UITableViewStylePlain];
    dynamicTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    dynamicTableView.delegate=self;
    dynamicTableView.dataSource=self;
    [self.view addSubview:dynamicTableView];

}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier=@"ReviewTableIdentifier";
    ReviewForBookingCell *cell=[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if(cell==nil)
    {
        cell=[[ReviewForBookingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    [cell configureCell:[displayItem objectAtIndex:indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
