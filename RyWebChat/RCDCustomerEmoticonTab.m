//
//  RCDCustomerEmoticonTab.m
//  RyWebChat
//
//  Created by nwk on 2017/2/9.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "RCDCustomerEmoticonTab.h"
#import "MAEmojiView.h"

@interface RCDCustomerEmoticonTab()<MAEmojiViewDelegate>

@property (strong, nonatomic) MAEmojiView *emojiView;
@property (assign, nonatomic) id<RCDCustomerEmoticonTabDelegate> delegate;
@end

@implementation RCDCustomerEmoticonTab

+ (instancetype)newEmoticonTab:(id<RCDCustomerEmoticonTabDelegate>)delegate {
    RCDCustomerEmoticonTab *emojiTab = [RCDCustomerEmoticonTab new];
    emojiTab.delegate = delegate;
    return emojiTab;
}

- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index {
    
    self.emojiView = [[MAEmojiView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 186)];
    self.emojiView.delegate = self;
    self.pageCount = (int)self.emojiView.pageControl.numberOfPages;
    
    return self.emojiView;
}


- (void)deleteEmojiEvent:(MAEmojiView *)emojiView {
    [self.delegate deleteLastEmojiEvent];
}

- (void)touchEmojiEvent:(MAEmojiView *)emojiView emojiName:(NSString *)name {
    [self.delegate touchEmojiEvent:name];
}

@end
