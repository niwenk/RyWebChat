//
//  MANewEmojiView.m
//  SocketDemo
//
//  Created by nwk on 2017/1/9.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MAEmojiView.h"
#import "MAEmojiUtil.h"
#import "Masonry.h"

@interface MAEmojiView()<UIScrollViewDelegate>
{
    CGFloat emojiColum;
    CGFloat emojiRow;
    int emojiNum;
    int pageNum;
    CGFloat emojiInvertx;
    CGFloat emojiInverty;
}

@property (strong, nonatomic) UIScrollView *emojiScrollView;
@property (strong, nonatomic, readwrite) UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *emojiArray;

@end

@implementation MAEmojiView

static int emojiWidth = 30;
static int emojiHeight = 30;
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.image = [UIImage imageNamed:@"chat_bg_default"];
        [self addSubview:imageView];
        
        self.emojiArray = [MAEmojiUtil getEmojiArray];
        
        [self addSubview:self.emojiScrollView];
        
        [self addSubview:self.pageControl];
        
        WS(ws);
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.mas_top);
            make.left.equalTo(ws.mas_left);
            make.right.equalTo(ws.mas_right);
            make.bottom.equalTo(ws.mas_bottom);
        }];
        [self.emojiScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.mas_top);
            make.left.equalTo(ws.mas_left);
            make.right.equalTo(ws.mas_right);
            make.bottom.equalTo(ws.mas_bottom).offset(-20);
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.emojiScrollView.mas_bottom);
            make.left.equalTo(ws.mas_left);
            make.right.equalTo(ws.mas_right);
            make.bottom.equalTo(ws.mas_bottom);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    
    return self;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight ||
        orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左、右
    {
        NSLog(@"home键靠左、右");
    }
    
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"home键靠上、下");
    }
    
    [self setNeedsDisplay];//重绘
}

- (UIScrollView *)emojiScrollView {
    if (!_emojiScrollView) {
        _emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _emojiScrollView.pagingEnabled = YES;
        _emojiScrollView.delegate = self;
        _emojiScrollView.showsVerticalScrollIndicator = NO;
        _emojiScrollView.showsHorizontalScrollIndicator= NO;
    }
    
    return _emojiScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.numberOfPages = pageNum;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.tag = 101;
        [_pageControl addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;
}

- (void)initParamer {
    emojiInvertx = 10;
    emojiInverty = 10;
    
    emojiColum = (CGRectGetWidth(self.emojiScrollView.bounds)-emojiInvertx)/(emojiWidth+emojiInvertx);
    emojiRow = CGRectGetHeight(self.emojiScrollView.bounds)/(emojiHeight+emojiInverty);
    NSArray *tempArray = [[NSString stringWithFormat:@"%.2f",emojiColum] componentsSeparatedByString:@"."];
    emojiColum = [tempArray.firstObject floatValue];
    CGFloat x = [tempArray.lastObject floatValue]/100 * (emojiWidth+emojiInvertx) / (emojiColum+1);
    emojiInvertx += x;
    
    tempArray = [[NSString stringWithFormat:@"%.2f",emojiRow] componentsSeparatedByString:@"."];
    emojiRow = [tempArray.firstObject floatValue];
    CGFloat y = [tempArray.lastObject floatValue]/100 * (emojiHeight+emojiInverty) / (emojiRow+1);
    emojiInverty += y;
    
    emojiNum = emojiColum * emojiRow -1;
    
    //当前表情包有多少页
    if(self.emojiArray.count%emojiNum == 0){
        pageNum = (int)self.emojiArray.count/emojiNum;
    }else{
        pageNum = (int)self.emojiArray.count/emojiNum+1;
    }
    
    self.emojiScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*pageNum, CGRectGetHeight(self.emojiScrollView.bounds));
    self.emojiScrollView.contentOffset = CGPointMake(0, 0);
    
    self.pageControl.numberOfPages = pageNum;
    self.pageControl.currentPage = 0;
    
    NSLog(@"---%f----%f----%d----%d",emojiColum,emojiRow,emojiNum,pageNum);
}



- (void)drawRect:(CGRect)rect {
    
    [self initParamer];
    
    for (UIView *view in self.emojiScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i=0; i<pageNum; i++) {
        
        for (int j=0; j<emojiRow; j++) {
            
            for (int k=0; k<emojiColum; k++) {
                
                CGFloat x = i * CGRectGetWidth(rect) + emojiInvertx + k * (emojiWidth+emojiInvertx);
                CGFloat y = emojiInverty + j * (emojiHeight+emojiInverty);
                
                if (j == emojiRow-1 && k == emojiColum-1) {
                    NSInteger index = -2;
                    [self createBtn:CGRectMake(x, y, emojiWidth, emojiHeight) index:index];
                }
//                else if (j == emojiRow-1 && k == emojiColum-1) {
//                    NSInteger index = -1;
//                    [self createBtn:CGRectMake(x, y, emojiWidth, emojiHeight) index:index];
//                }
                else {
                    NSInteger index = i*emojiNum+j*emojiColum+k;
                    [self createBtn:CGRectMake(x, y, emojiWidth, emojiHeight) index:index];
                }
            }
            
        }
    }
}

- (UIButton *)createBtn:(CGRect)frame index:(NSInteger)index {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = frame;
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = index;
    
    if (index == -2) { // 删除按钮
        NSString *imageName = @"RongCloud.bundle/emoji_btn_delete";
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteEmojiEvent:) forControlEvents:UIControlEventTouchUpInside];
    } else if (index == -1) {
//        NSString *imageName = @"RongCloud.bundle/keyboard_send";
//        [button setImage:[UIImage imageNamed:MAEmojiBundleName(imageName)] forState:UIControlStateNormal];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendEmojiEvent:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        NSString *imageName = [NSString stringWithFormat:@"MAEmoji.bundle/%zd",index];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchEmojiEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.emojiScrollView addSubview:button];
    
    return button;
}
/**
 *  删除表情
 *
 *  @param btn
 */
- (void)deleteEmojiEvent:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteEmojiEvent:)]) {
        [self.delegate deleteEmojiEvent:self];
    }
}
/**
 *  发送表情
 *
 *  @param btn
 */
- (void)sendEmojiEvent:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendEmojiEvent:)]) {
        [self.delegate sendEmojiEvent:self];
    }
}
/**
 *  点击表情
 *
 *  @param btn
 */
- (void)touchEmojiEvent:(UIButton *)btn {
    NSString *emoji = [MAEmojiUtil convertEmojiNameWithIndex:btn.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchEmojiEvent:emojiName:)]) {
        [self.delegate touchEmojiEvent:self emojiName:emoji];
    }
}

- (void)pageClick:(UIPageControl *)page {
    [self.emojiScrollView scrollRectToVisible:CGRectMake(page.currentPage*self.emojiScrollView.frame.size.width, 0, self.emojiScrollView.bounds.size.width, self.emojiScrollView.bounds.size.height) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint curPoint = scrollView.contentOffset;
    self.pageControl.currentPage = curPoint.x/scrollView.frame.size.width;
}
@end
