//
//  ProfileAndPayMentInfoController.m
//  Amgine
//
//   on 30/07/14.
//   
//

#import "ProfileAndPayMentInfoController.h"
#import "ScreenInfo.h"
#import "TravelerViewController.h"
@interface ProfileAndPayMentInfoController ()

@end

@implementation ProfileAndPayMentInfoController
{
    float screenHeight;
    float screenWidth;
    UITableView *dynamicTableView;
    NSMutableArray *displayItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    displayItem=[[NSMutableArray alloc]initWithObjects:@"Enter Profile info",@"Enter Payment info",nil];
    [self addCustomTableView];
    
    // Do any additional setup after loading the view.
}

#pragma mark  tableViewSpecific Function
#pragma mark TableViewSpecificFunction
-(void)addCustomTableView
{
    dynamicTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,320,screenHeight) style:UITableViewStylePlain];
   // dynamicTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    cell.textLabel.text=[displayItem objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"IndexPath.row=%li",(long)indexPath.row);
    if(indexPath.row==0)
    {
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TravelerViewController *travellerInfo=[stroyBoard instantiateViewControllerWithIdentifier:@"Amgine_View_Controller"];
        [self.navigationController pushViewController:travellerInfo animated:YES];
    }
   
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
