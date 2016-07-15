//
//  AuthorZLView.m
//  小说详情
//
//  Created by Lv on 16/7/6.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "AuthorZLView.h"
#define JJGREEN [UIColor colorWithRed:33.0/255 green:133.0/255.0 blue:94.0/255.0 alpha:1]
@implementation AuthorZLView
{
    id _target;
    SEL _action;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    self.userInteractionEnabled = YES;
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"作者专栏";
    label.font = [UIFont systemFontOfSize:12.0f];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = JJGREEN;
    [self addSubview:label];

    self.label = label;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(0, 0, self.bounds.size.width -5, self.bounds.size.height-5);
    self.label.center = (CGPoint){self.bounds.size.height * 0.5,self.bounds.size.height * 0.5};
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2)];
    [JJGREEN set];
    
    [path stroke];

}
- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_target && [_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
}

@end
