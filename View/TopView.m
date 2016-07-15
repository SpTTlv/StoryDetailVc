//
//  TopView.m
//  小说详情
//
//  Created by Lv on 16/7/5.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "TopView.h"
#import "NSString+Fit.h"
#import "FourButtonView.h"
#import "UIImageView+WebCache.h"
#define ColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0f]
#define GRAY_Label ColorRGB(180, 180, 180)

#define PAD 5

@interface TopView()

@end
@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
        
    }
    return self;
}
//初始化方法
- (void)setUpUI
{
    self.userInteractionEnabled = YES;
    self.backgroundColor  = [UIColor whiteColor];
    //文章图片
    UIImageView * imageV = [[UIImageView alloc] init];
    [self addSubview:imageV];
    self.topImage = imageV;
    
    //文章名字
    UILabel * bookName = [[UILabel alloc] init];
    bookName.font = [UIFont systemFontOfSize:18.0f];
    bookName.textColor = [UIColor blackColor];
    [self addSubview:bookName];
    self.bookName = bookName;
    //作者
    UILabel * authorName = [[UILabel alloc] init];
    authorName.font = [UIFont systemFontOfSize:18.0f];
    authorName.textColor = [UIColor grayColor];
    [self addSubview:authorName];
    self.authorName = authorName;
    
    //文章类型
    UILabel * bookStyle = [[UILabel alloc] init];
    bookStyle.font = [UIFont systemFontOfSize:10.0f];
    bookStyle.textColor = GRAY_Label;
    [self addSubview:bookStyle];
    self.bookStyle = bookStyle;
    //全文字数
    UILabel * bookNum = [[UILabel alloc] init];
    bookNum.font = [UIFont systemFontOfSize:10.0f];
    bookNum.textColor = GRAY_Label;
    [self addSubview:bookNum];
    self.bookNum = bookNum;
    //评论数
    UILabel * postNum = [[UILabel alloc] init];
    postNum.font = [UIFont systemFontOfSize:10.0f];
    postNum.textColor = GRAY_Label;
    [self addSubview:postNum];
    self.postNum = postNum;
    //非V点击
    UILabel * noVClick = [[UILabel alloc] init];
    noVClick.font = [UIFont systemFontOfSize:10.0f];
    noVClick.textColor = GRAY_Label;
    [self addSubview:noVClick];
    self.noVClick = noVClick;
    //文章积分
    UILabel * numerical= [[UILabel alloc] init];
    numerical.font = [UIFont systemFontOfSize:10.0f];
    numerical.textColor = GRAY_Label;
    [self addSubview:numerical];
    self.numerical = numerical;
    //作者专栏
    AuthorZLView * authorZL= [[AuthorZLView alloc] init];
    authorZL.userInteractionEnabled = YES;
   [self addSubview:authorZL];
    
    [authorZL setTarget:self action:@selector(authorZLClick)];
    
    self.authorZL = authorZL;
    //下载按钮
    UIButton * downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setImage:[UIImage imageNamed:@"download_btn"] forState:UIControlStateNormal];
    
    [downBtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:downBtn];
    self.downloadBtn = downBtn;
    
    //4个按钮
    FourButtonView * fourButtonView = [[NSBundle mainBundle] loadNibNamed:@"FourButtonView" owner:nil options:nil][0];
    fourButtonView.backgroundColor = ColorRGB(240, 240, 240);
    [self addSubview:fourButtonView];
    self.fourButtonView = fourButtonView;
    
    
    //最新章节 view
    LastUpdateView * lastView = [[LastUpdateView alloc] init];
    [self addSubview:lastView];
    self.lastView = lastView;
    
    //文章简介
    TargetLabel * contentL = [[TargetLabel alloc] init];
    
    contentL.textColor= ColorRGB(120, 120, 120);
    contentL.font = [UIFont systemFontOfSize:14.0f];
    [contentL setTarget:self action:@selector(contentLClick)];
    self.contentL = contentL;
    [self addSubview:contentL];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"reddown_arrow"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    self.clickBtn = btn;

    //主角 配角 其他
    UILabel * major = [[UILabel alloc] init];
    major.textColor = ColorRGB(0, 146, 108);
    major.font = [UIFont systemFontOfSize:12.0f];
    major.text = @"主角:阿萨德";
    [self addSubview:major];
    self.major = major;
    
    UILabel * costar = [[UILabel alloc] init];
    costar.textColor = ColorRGB(0, 146, 108);
    costar.font = [UIFont systemFontOfSize:12.0f];
    costar.text = @"配角:阿萨德";
    [self addSubview:costar];
    self.costar = costar;
    
    UILabel * other= [[UILabel alloc] init];
    other.text = @"其他:阿萨德";

    other.textColor = ColorRGB(0, 146, 108);
    other.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:other];
    self.other = other;
    
    UILabel * bottomGray = [[UILabel alloc] init];
    bottomGray.backgroundColor = ColorRGB(240, 239, 244);
    [self addSubview:bottomGray];
    self.bottonGray = bottomGray;
    
    UILabel * redPostLabel = [[UILabel alloc] init];
    redPostLabel.textColor = [UIColor redColor];
    redPostLabel.font = [UIFont systemFontOfSize:16.0f];
    redPostLabel.text = @"评论";
    [self addSubview:redPostLabel];
    self.redPostLabel = redPostLabel;
    
    //最底部
    UILabel * bottomGrayLast = [[UILabel alloc] init];
    bottomGrayLast.backgroundColor = ColorRGB(240, 240, 240);
    [self addSubview:bottomGrayLast];
    self.bottonGrayLast = bottomGrayLast;
    
    

}
//作者专栏点击
- (void)authorZLClick
{
    if (_authorZLBlock) {
        _authorZLBlock();
    }
    if (_delegateauthorZL && [_delegateauthorZL respondsToSelector:@selector(topViewauthorZL:)]) {
        [_delegateauthorZL topViewauthorZL:self];
    }

}

- (void)setModel:(TopModel *)model
{
    _model = model;
    _bookName.text = self.model.bookName;
    _authorName.text = self.model.authorName;
     _bookStyle.text = self.model.bookStyle;
     _bookNum.text = self.model.bookNum;
    _postNum.text = self.model.postNum;
    _noVClick.text = self.model.noVClick;
    _numerical.text = self.model.numerical;
    
    _major.text = self.model.protagonist;
    _costar.text = self.model.costar;
    _other.text = self.model.other;
    self.lastView.renewChapter.text = self.model.renewChapterName;
    [self.lastView.renewChapter sizeToFit];
    
    CGSize renewSize = [self.model.renewChapterName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    if (renewSize.width > (SCREEN_WITH - 10 - 63- 58)) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(labelRoll)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }

    
    _fourButtonView.collectCount.text = self.model.collectCount;
    _fourButtonView.bwTicketCount.text = self.model.bwTicketCount;
    _fourButtonView.irrigateCount.text = self.model.irrigateCount;
    
    [_topImage setImageWithString:self.model.imageName placeholderImage:nil];
    
    
    _contentL.text = self.model.contents;
    CGSize contentSize = [self.model.contents sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(SCREEN_WITH-20, 70) lineSpacing:LINESPACINGVALUE];
    self.contentSize = contentSize;
    if (contentSize.height >= 70) {
        _contentL.numberOfLines = 4;
    }else{
        _contentL.numberOfLines = 0;
    }
    


    
}
- (void)labelRoll
{
    CGPoint labelCenter = self.lastView.renewChapter.center;
    
    // 当控件的x坐标已经超过了视图的宽度
    
    if(labelCenter.x  <  self.lastView.labelView.frame.origin.x-self.lastView.renewChapter.frame.size.width){
        
        // 控制控件自视图右侧开始移动
        
        self.lastView.renewChapter.center = CGPointMake(self.lastView.labelView.frame.size.width+self.lastView.renewChapter.frame.size.width/2, labelCenter.y);
    }else{
        
        // 控制控件移动中(微调)
        
        self.lastView.renewChapter.center = CGPointMake(labelCenter.x-0.5, labelCenter.y);
    }
}
- (void)downClick
{
    if (_downBlock) {
        _downBlock();
    }
    if (_delegateDown && [_delegateDown respondsToSelector:@selector(topViewDown:)]) {
        [_delegateDown topViewDown:self];
    }
    
}
- (void)contentLClick
{
    [self clickShow:_clickBtn];

}
- (void)clickShow:(UIButton *)button
{
    if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"reddown_arrow"]]) {
        [button setBackgroundImage:[UIImage imageNamed:@"redup_arrow"] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"reddown_arrow"] forState:UIControlStateNormal];
    }
    
    
    if ([_delegate respondsToSelector:@selector(topViewBtnClick:)]) {
        [_delegate topViewBtnClick:self];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    *bookName;
//    *authorName;
//    * bookStyle;
//    * bookNum;
//    *postNum;
//    *noVClick;
//    *numerical;
//    authorZL;
//    *downloadBtn;
    
    
    
    self.topImage.frame = CGRectMake(PAD, PAD, 100, 140);
    
    CGFloat rightF = CGRectGetMaxX(_topImage.frame)+5;
    CGFloat width = self.bounds.size.width - 10-100;
    self.bookName.frame = CGRectMake(rightF, 10, width -45, 140/9 * 2-5);
    self.authorName.frame = CGRectMake(rightF, CGRectGetMaxY(self.bookName.frame)+ 5, width -45, 140/9 * 2-5);
    
    self.authorZL.frame = CGRectMake(self.bounds.size.width - 45,10 , 40, 40);
    
    self.bookStyle.frame = CGRectMake(rightF, CGRectGetMaxY(self.authorName.frame)+8, width, 140/9-8);
    
    self.bookNum.frame = CGRectMake(rightF, CGRectGetMaxY(self.bookStyle.frame)+8, width, 140/9-8);
    self.postNum.frame = CGRectMake(rightF, CGRectGetMaxY(self.bookNum.frame)+8, width, 140/9-8);
    self.noVClick.frame = CGRectMake(rightF, CGRectGetMaxY(self.postNum.frame)+8, width, 140/9-8);
    
    
    //downBtn
    self.downloadBtn.frame = CGRectMake(self.bounds.size.width - 30, CGRectGetMaxY(self.postNum.frame), 30, 30);
    
    self.numerical.frame = CGRectMake(rightF,CGRectGetMaxY(self.noVClick.frame)+8, width, 140/9-8);
    
    self.fourButtonView.frame = CGRectMake(0, CGRectGetMaxY(self.topImage.frame), self.bounds.size.width, 50);
    //最新更新
    self.lastView.frame = CGRectMake(0, CGRectGetMaxY(self.fourButtonView.frame), self.bounds.size.width, 30);
    
    _contentL.frame = (CGRect){{PAD,CGRectGetMaxY(_lastView.frame)+10},_contentSize};
    
    self.clickBtn.frame = CGRectMake(SCREEN_WITH-20-10, CGRectGetMaxY(self.contentL.frame), 10, 10);
    
    //主角 配角
    self.major.frame = CGRectMake(PAD, CGRectGetMaxY(_clickBtn.frame), self.bounds.size.width - PAD *2, 16);
    self.costar.frame = CGRectMake(PAD, CGRectGetMaxY(_major.frame), self.bounds.size.width - PAD *2, 16);
    self.other.frame = CGRectMake(PAD, CGRectGetMaxY(_costar.frame), self.bounds.size.width - PAD *2, 16);

    //灰色背景
    self.bottonGray.frame = CGRectMake(0, CGRectGetMaxY(_other.frame), self.bounds.size.width, 10);
    
    
    
    //评论
    self.redPostLabel.frame = CGRectMake(PAD, CGRectGetMaxY(_bottonGray.frame), self.bounds.size.width,30);
    
    self.bottonGrayLast.frame = CGRectMake(0, CGRectGetMaxY(_redPostLabel.frame), self.bounds.size.width, 10);

    
    self.viewH = CGRectGetMaxY(_bottonGrayLast.frame);
    
}

@end
