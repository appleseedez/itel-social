//
//  ContactCell.m
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIPanGestureRecognizer *gestreRecognizer;
@end

@implementation ContactCell
static float changelimit=100;
-(UIView*)backView{
    if (_backView==nil) {
        _backView=[[UIView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_backView];
        _backView.backgroundColor=[UIColor redColor];
    }
    return _backView;
}
-(UIView*)topView{
    if (_topView==nil) {
        _topView=[[UIView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_topView];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self backView];
    self.gestreRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
    
    [self.topView addGestureRecognizer:self.gestreRecognizer];
    if (self) {
        self.lbNickName=[[UILabel alloc]init];
        self.lbNickName.frame=CGRectMake(80, 3, 80, 25);
        self.lbNickName.backgroundColor=[UIColor clearColor];
        
        [self.topView addSubview:self.lbNickName];
        
        self.lbAlias=[[UILabel alloc] init];
        self.lbAlias.frame=CGRectMake(80, 28, 220, 40);
        self.lbAlias.backgroundColor=[UIColor clearColor];
        
        [self.lbAlias setFont:[UIFont fontWithName:@"HeiTi SC" size:12]];
        self.lbAlias.numberOfLines=0;
        [self.lbAlias setTextColor:[UIColor grayColor]];
        [self.topView addSubview:self.lbAlias];
        
        [self.topView addSubview:self.imageView];
        
    }
    return self;
}
-(void)panRecognizer:(UIPanGestureRecognizer*)recognizer{
   CGPoint translation=[recognizer translationInView: self.topView ];
    if (recognizer.state==UIGestureRecognizerStateChanged) {
        if ((self.topView.frame.origin.x>=-changelimit)&&(self.topView.frame.origin.x<=changelimit)) {
            
            CGFloat transX=0;
            if (translation.x>=changelimit) {
                transX=changelimit;
            }else if(translation.x<=-changelimit){
                transX=-changelimit;
            }
            else{
                transX=translation.x;
            }
            recognizer.view.transform=CGAffineTransformMakeTranslation(transX, 0);
        }
        
        
        
    }
   else if(recognizer.state==UIGestureRecognizerStateEnded){
       [UIView beginAnimations:@"back" context:nil];
       [UIView setAnimationDelay:0.2];
       self.topView.frame=self.contentView.bounds;
       [UIView commitAnimations];
       if (translation.x>changelimit) {
           NSLog(@"打电话");
       }
       else if (translation.x<-changelimit){
           NSLog(@"发短信");
       }
           
    }

   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
