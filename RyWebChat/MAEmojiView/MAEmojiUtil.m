//
//  MAEmojiUtil.m
//  KeyBoard
//
//  Created by nwk on 2016/12/27.
//  Copyright © 2016年 nwkcom.sh.n22. All rights reserved.
//

#import "MAEmojiUtil.h"

@implementation MAEmojiUtil

+ (NSArray *)getEmojiArray {
    return @[@"[微笑]", // 0
             @"[撇嘴]", // 1
             @"[色]", // 2
             @"[发呆]", // 3
             @"[得意]", // 4
             @"[流泪]", // 5
             @"[害羞]", // 6
             @"[闭嘴]", // 7
             @"[睡]", // 8
             @"[大哭]", // 9
             @"[尴尬]", // 10
             @"[发怒]", // 11
             @"[调皮]", // 12
             @"[呲牙]", // 13
             @"[惊讶]", // 14
             @"[难过]", // 15
             @"[酷]", // 16
             @"[冷汗]", // 17
             @"[抓狂]", // 18
             @"[吐]", // 19
             @"[偷笑]", // 20
             @"[可爱]", // 21
             @"[白眼]", // 22
             @"[傲慢]", // 23
             @"[饥饿]", // 24
             @"[困]", // 25
             @"[惊恐]", // 26
             @"[流汗]", // 27
             @"[憨笑]", // 28
             @"[大兵]", // 29
             @"[奋斗]", // 30
             @"[咒骂]", // 31
             @"[疑问]", // 32
             @"[嘘]", // 33
             @"[晕]", // 34
             @"[折磨]", // 35
             @"[衰]", // 36
             @"[骷髅]", // 37
             @"[敲打]", // 38
             @"[再见]", // 39
             @"[擦汗]", // 40
             @"[抠鼻]", // 41
             @"[鼓掌]", // 42
             @"[糗大了]", // 43
             @"[坏笑]", // 44
             @"[左哼哼]", // 45
             @"[右哼哼]", // 46
             @"[哈欠]", // 47
             @"[鄙视]", // 48
             @"[委屈]", // 49
             @"[快哭了]", // 50
             @"[阴险]", // 51
             @"[亲亲]", // 52
             @"[吓]", // 53
             @"[可怜]", // 54
             @"[菜刀]", // 55
             @"[西瓜]", // 56
             @"[啤酒]", // 57
             @"[篮球]", // 58
             @"[乒乓]", // 59
             @"[咖啡]", // 60
             @"[饭]", // 61
             @"[猪头]", // 62
             @"[玫瑰]", // 63
             @"[凋谢]", // 64
             @"[示爱]", // 65
             @"[爱心]", // 66
             @"[心碎]", // 67
             @"[蛋糕]", // 68
             @"[闪电]", // 69
             @"[炸弹]", // 70
             @"[刀]", // 71
             @"[足球]", // 72
             @"[瓢虫]", // 73
             @"[便便]", // 74
             @"[月亮]", // 75
             @"[太阳]", // 76
             @"[礼物]", // 77
             @"[拥抱]", // 78
             @"[强]", // 79
             @"[弱]", // 80
             @"[握手]", // 81
             @"[胜利]", // 82
             @"[抱拳]", // 83
             @"[勾引]", // 84
             @"[拳头]", // 85
             @"[差劲]", // 86
             @"[爱你]", // 87
             @"[NO]", // 88
             @"[OK]", // 89
             @"[爱情]", // 90
             @"[飞吻]", // 91
             @"[跳跳]", // 92
             @"[发抖]", // 93
             @"[怄火]", // 94
             @"[转圈]", // 95
             @"[磕头]", // 96
             @"[回头]", // 97
             @"[跳绳]", // 98
             @"[挥手]", // 99
             @"[激动]", // 100
             @"[街舞]", // 101
             @"[献吻]", // 102
             @"[左太极]", // 103
             @"[右太极]" // 104
             ];
}

+ (NSString *)convertEmojiNameWithIndex:(NSInteger)index {
    NSArray *emojis = [self getEmojiArray];
    if (index < emojis.count) {
        return [NSString stringWithFormat:@"%@",emojis[index]];
    }
    
    return nil;
}

+ (NSInteger)convertIndexWithEmojiName:(NSString *)name {
    NSArray *emojis = [self getEmojiArray];
    
    return [emojis indexOfObject:name];
}

/**
 *  光标位置输入
 *
 *  @param emoji 要输入的内容emoji和字符
 */
+ (void)insertStringWithGuangBiaotext:(UITextView *)textView emoji:(NSString *)emoji {
    NSRange range = textView.selectedRange;
    NSLog(@"%zd-光标位置输入-%zd",range.length,range.location);
    NSUInteger location  = textView.selectedRange.location;
    NSString * textStr = textView.text;
    NSString *resultStr = [NSString stringWithFormat:@"%@%@%@",[textStr substringToIndex:location],emoji,[textStr substringFromIndex:location]];
    textView.text = resultStr;
    range.location = range.location + [emoji length];
    NSLog(@"%zd=%zd+%zd",range.location,range.location,[emoji length]);
    textView.selectedRange = NSMakeRange(range.location,0);
}
/**
 *  光标位置删除
 */
+ (void)deleteString:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        //正则匹配要替换的文字的范围
        //正则表达式
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        //通过正则表达式来匹配字符串
        NSString *souceText = textView.text;
        NSArray *resultArray = [re matchesInString:souceText options:0 range:NSMakeRange(0, souceText.length)];
        
        NSTextCheckingResult *checkingResult = resultArray.lastObject;
        
        for (NSString *faceName in [MAEmojiUtil getEmojiArray]) {
            
            if ([souceText hasSuffix:@"]"]) {
                
                if ([[souceText substringWithRange:checkingResult.range] isEqualToString:faceName]) {
                    
                    NSLog(@"faceName %@", faceName);
                    
                    NSString *newText = [souceText substringToIndex:souceText.length - checkingResult.range.length];
                    
                    textView.text = newText;
                    return;
                }
            } else {
                NSRange range = textView.selectedRange;
                NSUInteger location  = range.location;
                NSString *head = [textView.text substringToIndex:location];
                if (range.length ==0) {
                    
                }else{
                    textView.text =@"";
                }
                
                if (location > 0) {
                    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",textView.text];
                    NSRange lastRange = [self lastRange:head];
                    
                    [str deleteCharactersInRange:lastRange];
                    textView.text = str;
                    textView.selectedRange = NSMakeRange(lastRange.location,0);
                    
                } else {
                    textView.selectedRange = NSMakeRange(0,0);
                }
                
                return;
            }
        }
    }
}

/**
 *  计算选中的最后一个是字符还是表情所占长度
 *
 *  @param str 要计算的字符串
 *
 *  @return 返回一个 NSRange
 */
+ (NSRange)lastRange:(NSString *)str {
    NSRange lastRange = [str rangeOfComposedCharacterSequenceAtIndex:str.length-1];
    return lastRange;
}

@end
