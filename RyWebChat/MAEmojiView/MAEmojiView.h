//
//  MANewEmojiView.h
//  SocketDemo
//
//  Created by nwk on 2017/1/9.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAEmojiView;

@protocol MAEmojiViewDelegate <NSObject>
@optional
- (void)touchEmojiEvent:(MAEmojiView *)emojiView emojiName:(NSString *)name;
- (void)sendEmojiEvent:(MAEmojiView *)emojiView;
- (void)deleteEmojiEvent:(MAEmojiView *)emojiView;
@end

@interface MAEmojiView : UIView

@property (assign, nonatomic) BOOL isShow;
@property (assign, nonatomic) id<MAEmojiViewDelegate> delegate;
@property (strong, nonatomic, readonly) UIPageControl *pageControl;

@end
