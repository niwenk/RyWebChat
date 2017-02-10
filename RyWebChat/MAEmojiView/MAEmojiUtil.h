//
//  MAEmojiUtil.h
//  KeyBoard
//
//  Created by nwk on 2016/12/27.
//  Copyright © 2016年 nwkcom.sh.n22. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MAEmojiUtil : NSObject

+ (NSArray *)getEmojiArray;

+ (NSString *)convertEmojiNameWithIndex:(NSInteger)index;

+ (NSInteger)convertIndexWithEmojiName:(NSString *)name;

/**
 *  光标位置删除
 */
+ (void)deleteString:(UITextView *)textView;
@end
