//
//  LastUpdateView.m
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "LastUpdateView.h"
#import "UIImage+image.h"

#import "TopModel.h"
#define ColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0f]
@implementation LastUpdateView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    UIImageView * imageV = [[UIImageView alloc] init];
    UIImage * imageS = [UIImage imageNamed:@"detail_white_btn_bg"];

    imageS = [imageS stretchableImageWithLeftCapWidth:imageS.size.width * 0.5 topCapHeight:imageS.size.height * 0.5];
    imageV.image = imageS;
    [self addSubview:imageV];
    self.backImage = imageV;
    
    UILabel * renewLabel = [[UILabel alloc] init];
    renewLabel.text = @"最新更新:";
    renewLabel.textAlignment = NSTextAlignmentCenter;
    renewLabel.textColor = [UIColor redColor];
    renewLabel.font = [UIFont systemFontOfSize:13.0f];
    [renewLabel sizeToFit];
    [self addSubview:renewLabel];
    
    
    
    CGSize renewSize = [renewLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    self.renewSize = renewSize;
    self.renewLabel = renewLabel;
    

    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = ColorRGB(0, 146, 108);
    [self addSubview:lineLabel];
    self.lineLabel = lineLabel;
    
    UIButton * directoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [directoryBtn setTitle:@"目录" forState:UIControlStateNormal];

    [directoryBtn setTitleColor:ColorRGB(0, 146, 108) forState:UIControlStateNormal];
    directoryBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [directoryBtn addTarget:self action:@selector(directoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:directoryBtn];
    self.directoryBtn = directoryBtn;
    

    UIView * labelView= [[UIView alloc] init];
    labelView.clipsToBounds = YES;
    [self addSubview:labelView];
    self.labelView = labelView;
    
    
    TargetLabel * renewChapter = [[TargetLabel alloc] init];
    renewChapter.font = [UIFont systemFontOfSize:13.0f];
    

    renewChapter.text = @"";
    renewChapter.textColor = ColorRGB(0, 146, 108);
    [renewChapter setTarget:self action:@selector(renewChapterClick)];
    [self.labelView addSubview:renewChapter];
    self.renewChapter = renewChapter;
    
}

- (void)renewChapterClick
{
    if (_delegateChapter && [_delegateChapter respondsToSelector:@selector(lastChapterDelegateLast:)]) {
        [_delegateChapter lastChapterDelegateLast:self];
    }


}
- (void)directoryBtnClick
{
    if (_delegateDirectory && [_delegateDirectory respondsToSelector:@selector(lastDirectoryDelegateLast:)]) {
        [_delegateDirectory lastDirectoryDelegateLast:self];
    }
}
- (void)layoutSubviews
{
    CGFloat VeiwWidth = self.bounds.size.width;
    CGFloat ViewHeight = self.bounds.size.height;
    self.backImage.frame = CGRectMake(0, 0, VeiwWidth, ViewHeight);
    
    self.renewLabel.frame = CGRectMake(5,0, _renewSize.width, ViewHeight);
    
    self.labelView.frame = CGRectMake(CGRectGetMaxX(_renewLabel.frame)+3, 0, VeiwWidth - CGRectGetMaxX(_renewLabel.frame)-3- 60-3, ViewHeight);
    CGSize renewSize = [self.renewChapter.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    
    self.renewChapter.frame = CGRectMake(0, 0, renewSize.width, self.labelView.bounds.size.height);
    
    self.lineLabel.frame = CGRectMake(VeiwWidth - 60-2, 3, 1, ViewHeight - 6);
    
    self.directoryBtn.frame = CGRectMake(VeiwWidth - 60, 0, 60, ViewHeight);
    
    
}


@end
