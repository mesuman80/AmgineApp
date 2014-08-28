//
//  DropDownListView.h
//  KDropDownMultipleSelection
//


@protocol kDropDownListViewDelegate;
@interface DropDownListView : UIView<UITableViewDataSource,UITableViewDelegate>{

    UITableView *_kTableView;
    NSString *_kTitleText;
    
    CGFloat R,G,B,A;
    BOOL isMultipleSelection;
}
@property(nonatomic,strong)NSMutableArray *arryData;
@property(nonatomic,strong)NSArray *_kDropDownOption;
@property (nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)NSString *objectType;
@property (nonatomic, assign) id<kDropDownListViewDelegate> delegate;
- (void)fadeOut;
// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple;
// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
-(void)SetBackGroundDropDwon_R:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alph;
@end

@protocol kDropDownListViewDelegate <NSObject>
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex;
- (void)DropDownListViewDidCancel:(DropDownListView *)dropdownListView;
@end
