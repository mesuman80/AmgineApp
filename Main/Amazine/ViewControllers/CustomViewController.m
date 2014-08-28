//
//  CustomViewController.m
//  Amgine
//


#import "CustomViewController.h"
#import "Data.h"
#import "Constants.h"


@interface CustomViewController()
{
    
}
@end

@implementation CustomViewController
{
    UITableView *countryTableView;
}
@synthesize displayData,delegate;
@synthesize textField;
@synthesize objectType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self drawCancelButton];
    [self tableViewSetUp];
    
}
#pragma mark navigation Button setup
-(void)drawCancelButton
{
   // [self.view resignFirstResponder];
    UIBarButtonItem *cacelButton =[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnCancel:)];
    self.navigationItem.leftBarButtonItem=cacelButton;
    
}
-(void)touchOnCancel:(id)sender
{
    [self dismissViewController];
}
-(void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TableView Specific Function

-(void)tableViewSetUp
{
  //  displayData=[Data sharedData].countryArray;
    countryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self
                                                                  .view.frame.size.height) style:UITableViewStylePlain];
    [countryTableView setDelegate:self];
    [countryTableView setDataSource:self];
     countryTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     [self.view addSubview:countryTableView];
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"counrtyCell"];
    if([objectType isEqualToString:AmgineCountryCode])
    {
        NSDictionary *dictionary =[displayData objectAtIndex:indexPath.row];
        NSString *cellString=[dictionary objectForKey:@"name"];
        cell.textLabel.text=cellString;
        
    }
    else
    {
      cell.textLabel.text=[displayData objectAtIndex:indexPath.row];
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if(delegate)
     {
         [delegate didSelectRowAtIndexPath:indexPath array:displayData withTextField:textField];
     }
     [self dismissViewController];
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
