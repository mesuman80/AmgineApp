//
//  DropDownListView.m
//  KDropDownMultipleSelection
//

//

#import "DropDownListView.h"
#import "DropDownViewCell.h"
#import "Constants.h"

#define DROPDOWNVIEW_SCREENINSET 0
#define DROPDOWNVIEW_HEADER_HEIGHT 50.
#define RADIUS 0


@interface DropDownListView (private)
- (void)fadeIn;
- (void)fadeOut;

@end
@implementation DropDownListView
{
   
}
@synthesize _kDropDownOption;
@synthesize textField;
@synthesize objectType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple
{
    isMultipleSelection=isMultiple;
    CGRect rect = CGRectMake(point.x, point.y,size.width,size.height);
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        _kTitleText = [aTitle copy];
        _kDropDownOption = aOptions;
        self.arryData=[[NSMutableArray alloc]init];
        _kTableView = [[UITableView alloc] initWithFrame:CGRectMake(DROPDOWNVIEW_SCREENINSET,
                                                                   DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT,
                                                                   rect.size.width - 2 * DROPDOWNVIEW_SCREENINSET,
                                                                   rect.size.height - 2 * DROPDOWNVIEW_SCREENINSET - DROPDOWNVIEW_HEADER_HEIGHT - RADIUS)];
        _kTableView.separatorColor = [UIColor colorWithWhite:1 alpha:.2];
        _kTableView.backgroundColor = [UIColor clearColor];
        _kTableView.dataSource = self;
        _kTableView.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_kTableView];
       
        
    }
    return self;
}

#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
            if(self.delegate)
            {
                [self.delegate DropDownListViewDidCancel:self];
            }
            [self removeFromSuperview];
        
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_kDropDownOption count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"DropDownViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    cell = [[DropDownViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    cell.textLabel.textColor=[UIColor blackColor];
    if([objectType isEqualToString:AmgineCountryCode])
    {
        NSDictionary *dictionary =[_kDropDownOption objectAtIndex:indexPath.row];
        NSString *cellString=[dictionary objectForKey:@"name"];
        cell.textLabel.text=cellString;
        
    }
    else if ([objectType isEqualToString:AmgineProvinceCode])
    {
        NSDictionary *dictionary =[_kDropDownOption objectAtIndex:indexPath.row];
        NSString *cellString=[dictionary objectForKey:@"provincename"];
        cell.textLabel.text=cellString;
    }
    else
    {
         cell.textLabel.text = [_kDropDownOption objectAtIndex:indexPath.row] ;
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate )
    {
      [self.delegate DropDownListView:self didSelectedIndex:[indexPath row]];
    }
}

#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    
    
}

#pragma mark - DrawDrawDraw
- (void)drawRect:(CGRect)rect
{
    CGRect bgRect = CGRectInset(rect, DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET);
    CGRect titleRect = CGRectMake(DROPDOWNVIEW_SCREENINSET + 10, DROPDOWNVIEW_SCREENINSET + 10 + 5,
                                  rect.size.width -  2 * (DROPDOWNVIEW_SCREENINSET + 10), 30);
    CGRect separatorRect = CGRectMake(DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * DROPDOWNVIEW_SCREENINSET, 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:1.0].CGColor);
        [[UIColor colorWithRed:R/255 green:G/255 blue:B/255 alpha:A] setFill];
    
    float x = DROPDOWNVIEW_SCREENINSET;
    float y = DROPDOWNVIEW_SCREENINSET;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow

    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithWhite:1 alpha:1.] setFill];
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.0];
        UIColor *cl=[UIColor grayColor];
        
        
        NSDictionary *attributes = @{ NSFontAttributeName: font,NSForegroundColorAttributeName:cl};
        
        [_kTitleText drawInRect:titleRect withAttributes:attributes];
    }
    else
        [_kTitleText drawInRect:titleRect withFont:[UIFont systemFontOfSize:16.0]];
    
    CGContextFillRect(ctx, separatorRect);
    
}
-(void)SetBackGroundDropDwon_R:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alph{
    R=r;
    G=g;
    B=b;
    A=alph;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fadeOut];
    [textField endEditing:YES];
    [self removeFromSuperview];
    
}
@end
