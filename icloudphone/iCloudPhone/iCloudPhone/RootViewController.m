

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

const int ContentOffset=300;
const int ContentMinOffset=160;
const float MoveAnimationDuration = 0.3;
#define winFrame [UIApplication sharedApplication].delegate.window.bounds
@interface RootViewController (){
    BOOL sideBarShowing;
    CGFloat currentTranslate;
    UIPanGestureRecognizer *_panGestureReconginzer;
}
@property (strong,nonatomic) UIView *backView;
@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong,nonatomic) UIViewController *leftSideBarViewController;
@property (strong,nonatomic) UIViewController *contentViewController;
@end

@implementation RootViewController
/*移动contentView的动画，根据方向*/
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    //NSLog(@"%d",[[self.view subviews] count] );
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:{
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:{
                [_backView bringSubviewToFront:self.leftSideBarViewController.view];
                self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
          
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.backView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            // contentView-取消点击手势动画
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
            
            
        }else{
            [self contentViewAddTapGestures];// 加入点击手势事件
            sideBarShowing = YES;
        }
        currentTranslate = self.contentView.transform.tx;
       // NSLog(@"tx=%f",self.contentView.transform.tx);
	};
    self.contentView.userInteractionEnabled = NO;
    self.backView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

-(void)setLeftSideBarViewController:(UIViewController *)leftSideBarViewController{
    if (_leftSideBarViewController!=nil) {
        _leftSideBarViewController=nil;
    }
    _leftSideBarViewController=leftSideBarViewController;
    [self.backView addSubview:_leftSideBarViewController.view];
}
-(void)setContentViewController:(UIViewController *)contentViewController{
    if (_contentViewController!=nil) {
        _contentViewController=nil;
    }

    _contentViewController=contentViewController;
    [self.contentView addSubview:contentViewController.view];
}
-(UIView*)backView{
    if (_backView==nil) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
   
    return _backView;
}
-(UIView*)contentView{
    if (_contentView==nil) {
       _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        
    }
    
    
    return _contentView;
}


- (void)viewDidLoad
{
    
        [super viewDidLoad];
   
    [self.view setAutoresizesSubviews:YES];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.contentView];
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 0;
//
    self.contentView.frame=winFrame;
    self.backView.frame=winFrame;
    
    self.backView.backgroundColor=[UIColor blackColor];
    
    
    self.contentView.backgroundColor = [UIColor redColor];
    
    
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [self.contentView addGestureRecognizer:_panGestureReconginzer];
	// Do any additional setup after loading the view.
}
- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
    
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
    {
        // 滑动的距离：X轴：左为负，右为正；Y轴：上为负，下为正。
        [panGestureReconginzer translationInView:self.contentView];
       // NSLog(@"拖动点相关坐标：x=%f,y=%f",point.x,point.y);
        //NSLog(@"当前的坐标值：x=%f",currentTranslate);
        
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        // 移动contentView
        if (translation+currentTranslate>0) {
             self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        }
       
        
	} else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
    {
		currentTranslate = self.contentView.transform.tx;
        if (!sideBarShowing) {
            if (fabs(currentTranslate)<ContentMinOffset) {
                
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                
            }else if(currentTranslate>ContentMinOffset){
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                
            }else{
                
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }else{
            if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                
            }else if(currentTranslate>ContentOffset-ContentMinOffset){
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                
            }else{
                
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
        
        
	}
    
    
}

- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
       
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}
- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
     [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
