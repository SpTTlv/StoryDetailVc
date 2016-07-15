//
//  StoryDetailNewViewController.m
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "StoryDetailNewViewController.h"

#define STRING_IS_NIL(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] <= 0)

//  写回复   #define WRITE_REPLY
#define Scr_Width [UIScreen mainScreen].bounds.size.width
#define Scr_Height [UIScreen mainScreen].bounds.size.height

#define ColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0f]

#define GRAY_Label ColorRGB(180, 180, 180)
@interface StoryDetailNewViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ReplyZhanKClickDelegate,
TopViewDelegate,
BeginToReadDelegate,
ReplyCommentDelegate,
UIAlertViewDelegate,UITextViewDelegate,
LastChapterDelegate,LastDirectoryDelegate,
BWPCancelDelegate,IrrigateCancelDelegate,IrrigateSureDelegate
>

@property (nonatomic, strong)TopView * topView;

@property (nonatomic,assign) BOOL  btnOn;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,weak) UITableView * tableView;
/**
 *  书籍信息 字典
 */
@property (nonatomic,strong) NSDictionary *bookAllInfoDict;



@end

@implementation StoryDetailNewViewController
{
    CGFloat ff;
    
    UIView * replyView;
    //view的textview
    UITextView *iView0;
    UITextView *iView;
    UILabel *backgroundname;
    //覆盖textview的button
    UIButton *btntextView ;
    //回复的名字和内容
    NSString *replyName;
    NSString *replyContent;

    NSMutableArray *mufu;//收藏到 分类  分类的名字数组

}

- (NSDictionary *)dictData
{
    if (_dictData == nil) {
        _dictData = [NSMutableDictionary dictionary];
    }
    return _dictData;
}
-  (NSDictionary *)isCollertDict
{
    if (_isCollertDict == nil) {
        _isCollertDict = [NSDictionary dictionary];
    }
    return _isCollertDict;
}
- (NSDictionary *)bookAllInfoDict
{
    if (_bookAllInfoDict == nil) {
        _bookAllInfoDict = [NSDictionary dictionary];
    }
    return _bookAllInfoDict;
}
- (NSMutableArray *)arrayData
{
    if (_arrayData == nil) {
        _arrayData = [[NSMutableArray alloc] init];
    }
    return _arrayData;
}
- (id)init:(NSString *)novelId{
    self = [super init];
    if (self)
    {
        _inovelId = novelId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    backgroundname = [[UILabel alloc]init];
    backgroundname.textColor = [UIColor whiteColor];
    self.cancelKeyboardBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelKeyboardBt.frame = CGRectMake(SCREENWIDTH - 60, 408, 60, 30);
    self.cancelKeyboardBt.backgroundColor = [UIColor lightGrayColor];
    [self.cancelKeyboardBt setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelKeyboardBt addTarget:self action:@selector(cancelBtAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelKeyboardBt.hidden = YES;
    self.view.backgroundColor = ColorRGB(240, 240, 240);
    [self.view addSubview:self.cancelKeyboardBt];
    [self initNav];
    //请求footer header 数据
    [self initDataTopView];
    
    // 请求 tableView 数据
    [self initDataTableView];
    
    //添加tableView
    [self initTab];
    
    
    [self setLeftBackBarButton];
    if([self checkNetWork] == false){
        [self NotNetwork];
        return;
    }
    
}
- (void)cancelBtAction:(UIButton *)canclebutton
{
    //键盘上的取消按钮
    self.cancelKeyboardBt.hidden = YES;
    [iView resignFirstResponder];
    [iView0 resignFirstResponder];
}
- (void)initNav
{
    NSDictionary * attributeDic =@{
                                   NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                   NSForegroundColorAttributeName:[UIColor whiteColor]
                                   };
    self.navigationItem.title = @"小说详情";
    [self.navigationController.navigationBar setTitleTextAttributes:attributeDic];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

    //对键盘notify的响应，以实现历史记录的尺寸，在输入法变化时，动态变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    [self initCollectionAFN];

}
- (void)initCollectionAFN
{
    NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,FAVORITE_STATUS];
    NSString * token = [self getPreference:@"token"];
    if (STRING_IS_NIL(token)) {
        token = @"";
    }
    NSDictionary * params = @{
                              @"token":token,
                              @"favData":_inovelId
                              };
    @weakify(self);
    [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
        @strongify(self);
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData * jsondata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.collect = @"no";
            self.topView.fourButtonView.collectLabel.text = @"收藏";
        }else if([dic isKindOfClass:[NSArray class]]){
            NSArray * dicArr = (NSArray *)dic;
        self.isCollertDict = dicArr[0];

        NSString * collect =@"收藏";
        self.collect = @"no";
        if ([dicArr[0][@"status"] isEqualToString:@"yes"]) {
            collect = @"已收藏";
            self.collect = @"yes";
        }

        self.topView.fourButtonView.collectLabel.text = collect;
        }
    } withFailedBlock:^(NSError *error) {
        
    } withErrorBlock:^(NSString *message) {
        
    }];

}
- (void)setLeftBackBarButton
{

    UIImage * imageLeftBack =[UIImage imageWithOriginalImageName:@"back_bookshop.png"];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageLeftBack style:UIBarButtonItemStylePlain target:self action:@selector(back)];


}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];

}
//请求tableview数据
- (void)initDataTableView
{
    if ([self checkNetWork]) {
        self.net.hidden = YES;
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,GET_COMMENT_LIST];
    NSDictionary * params = @{
                              @"novelId":_inovelId,
                              @"limit":@"5",
                              @"offset":@"0",
                           
                              };
    @weakify(self);
    [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
        @strongify(self);
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSData * jsondate = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondate options:NSJSONReadingMutableContainers error:nil];
        
        FooterView * footView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, Scr_Width-10, 70)];
        
        NSString * commentTotal = [NSString stringWithFormat:@"%@",dic[@"commentTotal"]];
        if ([commentTotal isEqualToString:@"0"] || STRING_IS_NIL(commentTotal)) {
             footView.contents = @"暂无评论,点击去评论吧";
        }else{
            footView.contents = [NSString stringWithFormat:@"查看更多(%@)条评论",commentTotal];
        }
        [footView setTarget:self action:@selector(footerViewClick)];
        
        self.tableView.tableFooterView = footView;
        
//        self.arrayData = dic[@"commentList"];
        int floorNum = 1;
        self.dictData = (NSMutableDictionary *)dic;
        for (NSDictionary * dict in dic[@"commentList"]) {
            
            DetailModel * model = [DetailModel modelWithDict:dict];
            DetailFrame * frameModel = [[DetailFrame alloc] init];
            frameModel.isAll = NO;
            if (dict[@"replyTotal"]) {
                frameModel.isFloorNum = [dict[@"replyTotal"] integerValue];
            }
            frameModel.model = model;
  
            [self.arrayData addObject:frameModel];
            floorNum ++;
        }
        [self.tableView reloadData];
  
    } withFailedBlock:^(NSError *error) {
        
    } withErrorBlock:^(NSString *message) {
        
    }];
    //   @"token":@""
    
}
//请求数据 头部视图View && footView
- (void)initDataTopView
{
    if ([self checkNetWork]) {
        self.net.hidden = YES;
    }
    NSString * url =[NSString stringWithFormat:@"%@%@",DOMAIN_NAME,NOVEL_BASIC_INFO];
    NSString * userToken  =[self getPreference:@"token"];
    if (!userToken) {
        userToken = @"";
    }
    // app版本
    NSString * app_Version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];

    NSDictionary * params = @{
                              @"novelId":_inovelId,
                              @"versionCode":app_Version,
                              @"token":userToken
                              };
    @weakify(self);
 [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
     @strongify(self);

    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSData * jsondate = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondate options:NSJSONReadingMutableContainers error:nil];
     
     self.bookAllInfoDict = dic;
     //创建头部视图
     if (_topView == nil) {
         
         TopModel * model = [[TopModel alloc] init];
         model.imageName = dic[@"novelCover"];
         //有空格的contents
         NSMutableString * contentSpace = dic[@"novelIntro"];
         NSString * newcontent =[contentSpace stringByReplacingOccurrencesOfString:@"&lt;br/&gt;&lt;br/&gt;" withString:@"\n"];
         
         newcontent =[newcontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         
         model.contents = newcontent;
        
         model.bookName = dic[@"novelName"];
         model.authorName = dic[@"authorName"];
         
         NSString * novelStepStr = dic[@"novelStep"];
         
         if ([novelStepStr isEqualToString:@"0"]) {
             novelStepStr = @"(暂停)";
         }else if ([novelStepStr isEqualToString:@"1"]){
             novelStepStr = @"(连载中)";
         }else if ([novelStepStr isEqualToString:@"2"]){
             novelStepStr = @"(已完成)";
         }else{
             novelStepStr = @"";
         }
         
         model.bookNum = [NSString stringWithFormat:@"全文字数:%@%@",dic[@"novelSize"],novelStepStr];
         model.postNum = [NSString stringWithFormat:@"评论条数:%@",dic[@"comment_count"]];
         model.bookStyle = [NSString stringWithFormat:@"文章类型:%@",dic[@"novelClass"]];
         model.noVClick = [NSString stringWithFormat:@"非V点击:%@",dic[@"novip_clicks"]];
         model.numerical = [NSString stringWithFormat:@"文章积分:%@",dic[@"novelScore"]];
         model.protagonist =dic[@"protagonist"];
         model.costar = dic[@"costar"];
         model.other = [NSString stringWithFormat:@"内容标签:%@",dic[@"novelTags"]];
         
         model.renewChapterName = [NSString stringWithFormat:@"第%@章:%@ %@",dic[@"renewChapterId"],dic[@"renewChapterName"],dic[@"renewDate"]];;
        
         //收藏  霸王票  灌溉 数目
         model.collectCount = [NSString stringWithFormat:@"%@个",dic[@"novelbefavoritedcount"]];
         model.bwTicketCount = dic[@"ranking"];
         model.irrigateCount = [NSString stringWithFormat:@"%@瓶",dic[@"nutrition_novel"]];
         
         _btnOn = NO;
         TopView * topView = [[TopView alloc] initWithFrame:CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width - 10, 0)];
         //赋值
         //评论条数

         NSString * collect =@"收藏";
         if ([self.isCollertDict[@"status"] isEqualToString:@"yes"]) {
             collect = @"已收藏";
         }
         
         topView.fourButtonView.collectLabel.text = collect;
         topView.fourButtonView.delegate = self;
         
         topView.model =model;
         
         CGSize contentSize = [model.contents sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT) lineSpacing:0];
         if (contentSize.height >= 70) {
             contentSize.height = 70;
         }
         CGFloat height = 295 + contentSize.height +70+ 48- 20- 50-10 ;
         ff = height;
         topView.frame = CGRectMake(5, 64, SCREEN_WITH-10, height);
         topView.delegate = self;
         topView.lastView.delegateChapter = self;
         topView.lastView.delegateDirectory = self;
         topView.downBlock = ^(){
             [self downloadBook];
         };
         topView.authorZLBlock = ^(){
             //点击了作者专栏
             if (STRING_IS_NIL(self.bookAllInfoDict[@"authorId"])) {
                 [CommonMethod showMesg1:@"作者ID丢失!"];
                 return;
             }
             authorSpecialColumnViewController *authorSp = [[authorSpecialColumnViewController alloc]init:self.bookAllInfoDict[@"authorId"]];
             [self.navigationController pushViewController:authorSp animated:YES];
         };
         topView.fourButtonView.collectB = ^(){
             //收藏
             [self gotoCollect];
             
         };
         topView.fourButtonView.bwB = ^(){
             if([self checkNetWork] == false){
                 return;
             }
             NSString * tokenBwp =[self getPreference:@"token"];
             if (STRING_IS_NIL(tokenBwp) || [tokenBwp length] < 5) {
                 [self.navigationController pushViewController:[NSClassFromString(@"VisitorLoginVcViewController") new] animated:YES];
                 return;
             }
             
             [StoryDetailCoverView show];
             //霸王票
             if (_bwView == nil) {
                 
                 _bwView = [[NSBundle mainBundle] loadNibNamed:@"storyDetailBaWangView" owner:self options:nil][0];
                 _bwView.center = self.view.center;
                 [_bwView.sureButton addTarget:self action:@selector(bwpSureClick) forControlEvents:UIControlEventTouchUpInside];
                 _bwView.delegateCancel = self;
                 [[UIApplication sharedApplication].keyWindow addSubview:_bwView];
             }
             
             
         };
         topView.fourButtonView.irrigateB = ^(){
             if([self checkNetWork] == false){
                 return;
             }
             NSString * tokenBwp =[self getPreference:@"token"];
             if (STRING_IS_NIL(tokenBwp) || [tokenBwp length] < 5) {
                 [self.navigationController pushViewController:[NSClassFromString(@"VisitorLoginVcViewController") new] animated:YES];
                 return;
             }
             //灌溉
             [self initIrrigateView];
         
         };
         
         
         self.topView = topView;
         self.tableView.tableHeaderView = self.topView;
         

         [self.tableView beginUpdates];
         [self.tableView reloadData];
         [self.tableView endUpdates];
     }

     
     

    
} withFailedBlock:^(NSError *error) {
    
} withErrorBlock:^(NSString *message) {
    
}];

}
- (void)initIrrigateView
{
    [StoryDetailCoverView show];
    //灌溉
    IrrigateView * irriView = [IrrigateView showInPoint:self.view.center];

    irriView.delegateCancel = self;
    irriView.delegateSure = self;
}

#pragma mark = IrrigateCancelDelegate && Sure
- (void)irrigateCancelClick:(IrrigateView *)irriView
{
    void(^completion)()= ^(){
        [StoryDetailCoverView hide];
    };
    [irriView hideInPoint:self.view.center completion:completion];

}
- (void)irrigateSureClick:(IrrigateView *)irriView
{
    irriView.sureBtn.userInteractionEnabled = NO;
    [irriView.sureBtn setBackgroundColor:GRAY_Label];

    NSString * type = @"";
    for (UIButton * btn in irriView.arrAllBtn) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.selected) {
                if (btn.tag == 602) {
                    type = @"ALL";
                }else{
                    type = @"1";
                }
            }
        }
    }
    NSString * number = @"";
    number = irriView.writeIrrigate.text;
    if (STRING_IS_NIL(number)) {
        number = @"";
    }
    if ([type isEqualToString:@""] && [number isEqualToString:@""]) {
        [CommonMethod showMesg1:@"请选择!"];
        [irriView.sureBtn setBackgroundColor:ColorRGB(93, 232, 198)];
        irriView.sureBtn.userInteractionEnabled = YES;
        return;
    }
    if ([type isEqualToString:@"1"]) {
        type = @"";
        number = @"1";
    }
    NSString * token = [self getPreference:@"token"];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    //加密
    NSString * desBwp = [NSString stringWithFormat:@"%@:%@:%@:%@:%@",timeSp,token,_inovelId,number,type];
    //加密
    NSString *ket = [NSString stringWithFormat:@"@c2heJ!myWhLwAno"];
    desBwp=[DESEncryption TripleDES:desBwp encryptOrDecrypt:kCCEncrypt key:ket];

    NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,Pay_Irrigate];
    NSDictionary * params = @{
                              @"sign":desBwp
                              };
    @weakify(self);
    [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
        @strongify(self);
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData * jsondata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (dic[@"message"]) {
                NSString * message = [NSString stringWithFormat:@"%@",dic[@"message"]];
                void(^completion)()= ^(){
                    [StoryDetailCoverView hide];
                    [CommonMethod showMesg1:message];
                };
                [irriView hideInPoint:self.view.center completion:completion];
            }
        }
        void(^completion)()= ^(){
            [StoryDetailCoverView hide];
        };
        [irriView hideInPoint:self.view.center completion:completion];
        [irriView.sureBtn setBackgroundColor:ColorRGB(93, 232, 198)];
        irriView.sureBtn.userInteractionEnabled = YES;
        
    } withFailedBlock:^(NSError *error) {
        @strongify(self);
        [irriView.sureBtn setBackgroundColor:ColorRGB(93, 232, 198)];
        irriView.sureBtn.userInteractionEnabled = YES;
        void(^completion)()= ^(){
            [StoryDetailCoverView hide];
        };
        
        [irriView hideInPoint:self.view.center completion:completion];
    } withErrorBlock:^(NSString *message) {
        @strongify(self);
        [irriView.sureBtn setBackgroundColor:ColorRGB(93, 232, 198)];
        irriView.sureBtn.userInteractionEnabled = YES;
        void(^completion)()= ^(){
            [StoryDetailCoverView hide];
        };
        
        [irriView hideInPoint:self.view.center completion:completion];
    }];
    
    

}
#pragma mark - BWPCancelDelegate
- (void)bwpCancelClick:(storyDetailBaWangView *)bwView
{
   void (^cancelView)() = ^(){
        [StoryDetailCoverView hide];
    };
    [bwView hideInPoint:self.view.center completion:cancelView];
}
- (void)bwpSureClick
{
    self.bwView.sureButton.userInteractionEnabled = NO;
    [self.bwView.sureButton setBackgroundColor:GRAY_Label];
    
    NSString * bwpStyle = @"";
    
    //霸王票 投
    for (UIButton * btn in self.bwView.allBtnArr) {
        if (btn.selected == YES) {
            bwpStyle = [NSString stringWithFormat:@"%ld",(long)(btn.tag - 501)];
        }
    }

          NSString * bwpNum =self.bwView.bwpNum.text;
    if (([bwpNum isEqualToString:@""] || STRING_IS_NIL(bwpNum) || [bwpNum isEqualToString:@"0"]) && [bwpStyle isEqualToString:@""]) {
        [CommonMethod showMesg1:@"请选择!"];
        self.bwView.sureButton.userInteractionEnabled = YES;
        [self.bwView.sureButton setBackgroundColor:ColorRGB(93, 232, 198)];
        return;
    }
    if ([bwpStyle isEqualToString:@""]) {
        bwpStyle = @"4";
    }
    if ([bwpNum isEqualToString:@""] || STRING_IS_NIL(bwpNum) || [bwpNum isEqualToString:@"0"]) {
        bwpNum = @"1";
    }
    
    NSString * token = [self getPreference:@"token"];
    if (STRING_IS_NIL(token) || [token length] < 5) {
        self.bwView.sureButton.userInteractionEnabled = YES;
        [self.bwView.sureButton setBackgroundColor:ColorRGB(93, 232, 198)];
        void (^cancelView)() = ^(){
            [StoryDetailCoverView hide];
            [self.navigationController pushViewController:[NSClassFromString(@"VisitorLoginVcViewController") new] animated:YES];
        };
        [_bwView hideInPoint:self.view.center completion:cancelView];
        
        

        
    }
    //加密
    NSString * desBwp = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@",token,_inovelId,@"novelid",bwpStyle,@"",@"",@"",@"",bwpNum];
    //加密
    NSString *ket = [NSString stringWithFormat:@"@c2heJ!myWhLwAno"];
    desBwp=[DESEncryption TripleDES:desBwp encryptOrDecrypt:kCCEncrypt key:ket];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,PAY_TICKETS];
    NSDictionary * params = @{
                              @"sign":desBwp
                              };
    @weakify(self);
    [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
        @strongify(self);
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData * jsondata = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];

        self.bwView.sureButton.userInteractionEnabled = YES;
        [self.bwView.sureButton setBackgroundColor:ColorRGB(93, 232, 198)];

        void (^cancelView)() = ^(){
            [StoryDetailCoverView hide];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                if (dic[@"message"]) {
                    [CommonMethod showMesg1:dic[@"message"]];
                }
            }


        };
        [_bwView hideInPoint:self.view.center completion:cancelView];
        
        
        
    } withFailedBlock:^(NSError *error) {
        @strongify(self);
        self.bwView.sureButton.userInteractionEnabled = YES;
        [self.bwView.sureButton setBackgroundColor:ColorRGB(93, 232, 198)];
        
        void (^cancelView)() = ^(){
            [StoryDetailCoverView hide];
        };
        [_bwView hideInPoint:self.view.center completion:cancelView];
    } withErrorBlock:^(NSString *message) {
        @strongify(self);
        self.bwView.sureButton.userInteractionEnabled = YES;
        [self.bwView.sureButton setBackgroundColor:ColorRGB(93, 232, 198)];
        
        void (^cancelView)() = ^(){
            [StoryDetailCoverView hide];
        };
        [_bwView hideInPoint:self.view.center completion:cancelView];
    }];
    
    
    
}
- (void)gotoCollect
{
    self.topView.fourButtonView.collectBtn.userInteractionEnabled = NO;
    NSString *Itoken = [self getPreference:@"token"];
    if ([Itoken length]<5) {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:nil
                            message:@"您尚未登录,收藏到哪里?"
                            delegate:self
                            cancelButtonTitle:@"取消"
                            otherButtonTitles:@"临时书架",@"去登录",nil];
        alert.alertViewStyle = 0;
        alert.tag = 9494;
        [alert show];
        return;
    }
    if ([self.collect isEqualToString:@"no"]) {
        //收藏到哪个分类。
        DBManager *manager = [DBManager shareManager];
        NSArray *fu = [manager fetchAllUsers];
        mufu = [[NSMutableArray alloc]init];
        for (int i = 0; i<[fu count]; i++) {
            UserModel *classModel = [fu objectAtIndex:i];
            NSString *name = classModel.className;
            NSString *classid = classModel.classId;
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:name,@"className",classid,@"classId" ,nil];
            [mufu addObject:dic];
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"分类至"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:nil];
        actionSheet.tag = 77;
        for (int i = 1; i<[mufu count]; i++) {
            NSString *name = [[mufu objectAtIndex:i] objectForKey:@"className"];
            [actionSheet addButtonWithTitle:name];
        }
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        
        
    }
    else if ([self.collect isEqualToString:@"yes"]){
        [self checkCodeDelFavorite];
    }else {
        [self checkCodeDelFavorite];
    }

}
#pragma mark - ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{


    if (actionSheet.tag==77){
        if (buttonIndex == 0) {
             self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;
        }
        else{
            NSString *clasId = [[mufu objectAtIndex:buttonIndex] objectForKey:@"classId"];
            [self checkCodeAddFavorite:clasId];
        }
    }

}
//删除收藏
- (void)checkCodeDelFavorite
{
    if([self checkNetWork] == false){
//        [self NotNetwork];
        return;
    }
//    [self showSpinner:YES];//加载圈
    NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,DEL_FAVORITE];
    NSString * token = [self getPreference:@"token"];
    if (STRING_IS_NIL(token)) {
        token = @"";
    }
    NSDictionary * params = @{
                              @"novelId":_inovelId,
                              @"token":token
                              
                              };
    @weakify(self);
    [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
        @strongify(self);
        self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData * jsondata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self.navigationController pushViewController:[NSClassFromString(@"VisitorLoginVcViewController") new] animated:YES];

        }else if ([dic isKindOfClass:[NSArray class]]) {
            NSArray * dicArr = (NSArray *)dic;
            
            if ([[[dicArr objectAtIndex:0] objectForKey:@"status"] isEqualToString:@"200"]) {
                [CommonMethod showMesg1:[NSString stringWithFormat:@"%@",[[dicArr objectAtIndex:0] objectForKey:@"message"]]];
                self.topView.fourButtonView.collectLabel.text = @"收藏";
                self.collect = @"no";
            }
        }
        else{
            NSArray * dicArr = (NSArray *)dic;

            [CommonMethod showMesg1:[NSString stringWithFormat:@"%@",[[dicArr objectAtIndex:0] objectForKey:@"message"]]];
            
        }

        
        
    } withFailedBlock:^(NSError *error) {
        self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

    } withErrorBlock:^(NSString *message) {
        self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

    }];

}
//添加收藏到分类
- (void)checkCodeAddFavorite:(NSString *)classId
{
    if([self checkNetWork] == false){
//        [self NotNetwork];
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,ADD_FAVORITE];
    NSDictionary * params = @{
                              @"novelId":_inovelId,
                              @"token":[self getPreference:@"token"],
                              @"classId":classId
                              };
    @weakify(self);
    [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
        @strongify(self);
        self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData * jsondata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            [self.navigationController pushViewController:[NSClassFromString(@"VisitorLoginVcViewController") new] animated:YES];
            
        }else{
            NSArray * dicArr = (NSArray *)dic;
            [CommonMethod showMesg1:[NSString stringWithFormat:@"%@",[[dicArr objectAtIndex:0]  objectForKey:@"message"]]];
        self.topView.fourButtonView.collectLabel.text = @"已收藏";
            self.collect = @"yes";
        }
        
    } withFailedBlock:^(NSError *error) {
        self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

    } withErrorBlock:^(NSString *message) {
        self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

    }];
    
}
#pragma mark = UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.topView.fourButtonView.collectBtn.userInteractionEnabled = YES;

    if (alertView.tag == 9494) {
        switch (buttonIndex) {
            case 0:{
                //取消
                break;
            }
            case 1:
            {
                [self temporaryAdd:YES];
            }
                break;
            case 2:{
                //去登录
                [self goRis];
            }
            default:
                break;
        }
    }
}
- (void)temporaryAdd:(BOOL)isInsert
{
    //临时书架
    temporaryBookshelfManager *temp = [temporaryBookshelfManager shareManager];
    BookshelfModel *model = [[BookshelfModel alloc]init];
    model.novelId = _inovelId;
    model.className = @"临时书架";
    model.novelName = _bookAllInfoDict[@"novelName"];
    model.novelCover = _bookAllInfoDict[@"novelCover"];
    model.Novelintroshort = _bookAllInfoDict[@"novelIntroShort"];
    model.Novelintro = _bookAllInfoDict[@"novelIntro"];
    model.novelClass = _bookAllInfoDict[@"novelStyle"];
    model.novelStep = _bookAllInfoDict[@"novelStep"];
    model.novelSize = _bookAllInfoDict[@"novelSize"];
    model.authorId = _bookAllInfoDict[@"authorId"];
    model.authorName = _bookAllInfoDict[@"authorName"];
    NSDate *datenow = [NSDate date];//现在时间
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    model.favoriteDate = timeSp;
    model.chapterCount = _bookAllInfoDict[@"maxChapterId"];
    model.lastChapterId = _bookAllInfoDict[@"renewChapterId"];
    model.lastChapterName = _bookAllInfoDict[@"renewChapterName"];
    model.lastChapterTime = _bookAllInfoDict[@"renewDate"];
    if (isInsert) {
        BOOL SUCC = [temp insertDataWithModel:model];
        if (SUCC) {
            [CommonMethod showMesg1:@"加入临时书架成功!"];
        }
    }
}
-(void)goRis{
    
    VisitorLoginVcViewController *loginVc = [[VisitorLoginVcViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
    
}
- (void)footerViewClick
{
    //查看更多评论
    allCommentController *all = [[allCommentController alloc]init:_inovelId];
    [self.navigationController pushViewController:all animated:YES];

}
- (void)initTab
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 44 + 20, Scr_Width-10, Scr_Height - 44 - 20) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;

    [self.view addSubview:tableView];
    self.tableView = tableView;


}
#pragma mark = tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryDetailTableViewCell * cell = [StoryDetailTableViewCell cellWithTableView:tableView];
    cell.delegateZKButton = self;
    cell.delegateReplyButton = self;
    cell.detailFrame = self.arrayData[indexPath.row];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailFrame * frame = self.arrayData[indexPath.row];
    
    return frame.cellHeight;
    
}
#pragma  mark - ReplyCommentDelegate
//点击 回复 按钮
- (void)replyCommentClickBtn:(StoryDetailTableViewCell *)cell
{
    if([self checkNetWork] == false){
        return;
    }
    //www
    NSString *tokenUser = [self getPreference:@"token"];
    if (STRING_IS_NIL(tokenUser) || [tokenUser length] < 5) {
        [self.navigationController pushViewController:[NSClassFromString(@"VisitorLoginVcViewController") new] animated:YES];
        return;
    }
    
    NSIndexPath * path = [self.tableView indexPathForCell:cell];

    self.pathRow = path.row;
    if (replyView) {
        [replyView removeFromSuperview];
        replyView = nil;
    }
    replyView = [[UIView alloc]initWithFrame:CGRectMake(0, Scr_Height - 150, Scr_Width, 150)];
    replyView.backgroundColor = [UIColor whiteColor];
    iView0 = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 115, 35)];
    iView0.backgroundColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1];
    iView0.delegate = self;
    iView0.tag = 256;
    backgroundname.enabled = NO;
    backgroundname.frame = CGRectMake(10, 10, 115, 35);
    //
    UserInformationManager *maneger = [UserInformationManager shareManager];
    UserInformationModel *model = [[UserInformationModel alloc]init];
    if ([[maneger fetchAllUsers] count]>0) {
        model = [[maneger fetchAllUsers] objectAtIndex:0];
        NSString *nikname = model.nickName;
        if ([nikname length]>0) {
            backgroundname.text = nikname;
            replyName = nikname;
        }
    }
    else{
        backgroundname.text = @" 昵称";
    }
    backgroundname.backgroundColor = [UIColor clearColor];
    [replyView addSubview:iView0];
    [replyView addSubview:backgroundname];
    UIButton *ireply = [UIButton buttonWithType:UIButtonTypeCustom];
    ireply.tag = path.row;
    ireply.frame = CGRectMake(Scr_Width - 70, 10, 60, 35);
    [ireply setBackgroundImage:[UIImage imageNamed:@"setting_btn_bg@2x"] forState:UIControlStateNormal];
    [ireply setTitle:@"回复" forState:UIControlStateNormal];
    [ireply addTarget:self action:@selector(ireply:) forControlEvents:UIControlEventTouchUpInside];
    [replyView addSubview:ireply];
    iView = [[UITextView alloc]initWithFrame:CGRectMake(10, 55, Scr_Width - 20, 85)];
    iView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    iView.delegate = self;
    iView.tag = 257;
    [replyView addSubview:iView];
    btntextView = [UIButton buttonWithType:UIButtonTypeCustom];
    btntextView.frame = CGRectMake(10, 55, Scr_Width - 30, 85);
    
    DetailFrame * frame = self.arrayData[path.row];
    NSString * commentAuthor = frame.model.commentAuthor;
    if (!commentAuthor) {
        commentAuthor = @"";
    }
    
    //nameArray
    [btntextView setTitle:commentAuthor forState:UIControlStateNormal];
    btntextView.titleLabel.textColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1];
    [btntextView addTarget:self action:@selector(iSShow) forControlEvents:UIControlEventTouchUpInside];
    [replyView addSubview:btntextView];
    [self.view addSubview:replyView];

    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.cancelKeyboardBt.hidden = NO;
    [self.view bringSubviewToFront:self.cancelKeyboardBt];
    replyView.frame = CGRectMake(0, replyView.frame.origin.y-250, IS_IPAD? 750 : SCREENWIDTH - 16, 150);
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self resignFirstResponder];
    if (textView.tag==256) {
        replyName = textView.text;
    }
    else if (textView.tag==257){
        replyContent = textView.text;
    }
    replyView.frame = CGRectMake(0, replyView.frame.origin.y+250, IS_IPAD? 750 : SCREENWIDTH - 16, 150);
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.tag==256) {
        backgroundname.text = @"";
        replyName = textView.text;
        if ([replyName isEqualToString:@""]||replyName==nil) {
            backgroundname.text = @" 昵称";
        }
    }
    else if (textView.tag==257){
        replyContent = textView.text;
    }
}
-(void)iSShow
{
    btntextView.hidden = YES;
    [iView becomeFirstResponder];

}
- (void)ireply:(UIButton *)button
{

    //点击了回复按钮
    replyView.hidden = YES;
    self.cancelKeyboardBt.hidden = YES;
    [iView resignFirstResponder];
    [iView0 resignFirstResponder];
    if ([replyName isEqualToString:@""]||replyName==nil) {
        replyName = @"路人甲";
    }
    
    replyContent = iView.text;
    if ([replyContent length]<1) {
        [CommonMethod showMesg:@"评论内容不能为空呦！"];
        return;
    }
    [self checkCodeReply];

    
    
}
- (void)checkCodeReply
{
    if([self checkNetWork] == false){
//        [self NotNetwork];
        return;
    }
//    [self showSpinner:YES];
    //开始请求

     NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,WRITE_REPLY];
     
     //章节id  self.arrayData[path.row][@"chapterId"]
    DetailFrame * frame = self.arrayData[_pathRow];
     NSString * chapterID = frame.model.chapterId;
     if (!chapterID) {
     chapterID = @"";
     }
     //回复 对应的评论id  self.arrayData[path.row][@"commentId"]
     NSString * commentId = frame.model.commentId;
     if (!commentId) {
     commentId = @"";
     }
     
     NSString * commentToken = [self getPreference:@"token"];
     if (!commentToken) {
     commentToken = @"";
     }
     
     NSDictionary * params = @{
     @"novelId":_inovelId,
     @"chapterId":chapterID,
     @"commentBody":replyContent,
     @"commentId":commentId,
     @"commentAuthor":replyName,
     @"token":commentToken,
     };
     
    @weakify(self);
     [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
         @strongify(self);
     NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSData * jsondate = [str dataUsingEncoding:NSUTF8StringEncoding];
     NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondate options:NSJSONReadingMutableContainers error:nil];
         if([dic isKindOfClass:[NSDictionary class]])
         {
             if ([dic objectForKey:@"status"]) {
                 [CommonMethod showMesg:@"回复成功"];
                 NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"isAuthor",replyName,@"replyAuthor",replyContent,@"replyBody",@"刚刚",@"replyDate", nil];

                 if (self.dictData[@"commentList"][_pathRow][@"replyAll"]) {
                     NSMutableArray * replyArr =[[NSMutableArray alloc] initWithArray:self.dictData[@"commentList"][_pathRow][@"replyAll"]];
                     [replyArr addObject:dic];
                     
                     NSArray * replyArrTemp = [[NSArray alloc] initWithArray:replyArr];
                     NSDictionary * tempDic = self.dictData[@"commentList"][_pathRow];
                     [tempDic  setValue:replyArrTemp forKey:@"replyAll"];
                     [self.dictData[@"commentList"] replaceObjectAtIndex:_pathRow withObject:tempDic];
                     
                 }else{
                     NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:self.dictData[@"commentList"]];
                     NSMutableDictionary * tempDic = arr[_pathRow];

                     [tempDic setValue:@[dic] forKey:@"replyAll"];
                     
//                     [self.dictData[@"commentList"] replaceObjectAtIndex:_pathRow withObject:tempDic];
                 }
                 //重新赋值
                 if (self.arrayData.count) {
                     [self.arrayData removeAllObjects];
                 }
                 int floorNum = 1;
                 for (NSDictionary * dict in self.dictData[@"commentList"]) {
                     
                     DetailModel * model = [DetailModel modelWithDict:dict];
                     DetailFrame * frameModel = [[DetailFrame alloc] init];
                     frameModel.isFloorNum = [dict[@"replyTotal"] integerValue];
                     if ([dict[@"replyTotal"] integerValue]==6) {
                         frameModel.isAll = YES;
                     }else{
                         frameModel.isAll = NO;
                     }
                     frameModel.model = model;

                     [self.arrayData addObject:frameModel];
                     floorNum ++;
                 }
 
                 
                 
             }
             else{
                 if ([dic objectForKey:@"message"]) {
                     [CommonMethod showMesg:[dic objectForKey:@"message"]];
                 }
                 else{
                     [CommonMethod showMesg:@"回复失败"];
                 }
                 
             }
         }
         else if ([dic isKindOfClass:[NSArray class]]){
             
         }
         [self.tableView reloadData];
     
     } withFailedBlock:^(NSError *error) {
     
     
     
     
     } withErrorBlock:^(NSString *message) {
     
     }];

 
}
#pragma  mark = delegateZKButton
- (void)replyZhanKClickBtn:(StoryDetailTableViewCell *)cell
{
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    DetailFrame * frameModel = self.arrayData[path.row];

    //点击查看剩余回复 点击
    //重新赋值
    NSString * url = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,Get_replyList];
    NSDictionary * params = @{
                              @"novelId":self.dictData[@"commentList"][path.row][@"novelId"],
                              @"chapterId":self.dictData[@"commentList"][path.row][@"chapterId"],
                              @"commentId":self.dictData[@"commentList"][path.row][@"commentId"],
                              @"offset":@"0",
                              @"limit":[NSString stringWithFormat:@"%ld",(long)frameModel.isFloorNum]
                              
                              };
    @weakify(self);
    [JJHTTPClient postUrlString:url withParam:params withSuccessBlock:^(id data) {
        @strongify(self);
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData * jsondata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        if ([dic isKindOfClass:[NSArray class]]) {
            NSArray * dicArr = (NSArray *)dic;//要替换的数组
            //模型重置

            if (self.arrayData.count) {
                [self.arrayData removeAllObjects];
            }
            NSArray * temp = [[NSArray alloc] initWithArray:_dictData[@"commentList"]];
             NSMutableArray * arrAll = [[NSMutableArray alloc] initWithArray:temp];
            NSMutableDictionary * dicChange = [NSMutableDictionary dictionaryWithDictionary:arrAll[path.row]];

            [dicChange setValue:dicArr forKey:@"replyAll"];
            [arrAll replaceObjectAtIndex:path.row withObject:dicChange];
            //change
            int floorNum = 1;
            for (NSDictionary * dict in arrAll) {
                
                DetailModel * model = [DetailModel modelWithDict:dict];
                DetailFrame * frameModel = [[DetailFrame alloc] init];
                frameModel.isAll = YES;
                if (dict[@"replyTotal"]) {
                    frameModel.isFloorNum = [dict[@"replyTotal"] integerValue];
                }
                frameModel.model = model;
                
                [self.arrayData addObject:frameModel];
                floorNum ++;
            }
            [self.tableView reloadData];
            
            
        }
        
        
    } withFailedBlock:^(NSError *error) {
        
    } withErrorBlock:^(NSString *message) {
        
    }];
    
    
    frameModel.isAll = NO;

    
    [self.arrayData replaceObjectAtIndex:path.row withObject:frameModel];
    [self.tableView reloadData];
    
    
    
    cell.isAllShow = frameModel.isAll;
    [cell.replyTableView reloadData];
}

//顶部视图
- (void)topViewBtnClick:(TopView *)topView
{
    _btnOn = !_btnOn;
    CGSize contentSize = [self.topView.contentL.text sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, _btnOn?MAXFLOAT:70) lineSpacing:0];
    self.topView.contentSize = contentSize;
    self.topView.contentL.numberOfLines = _btnOn?0:4;
    if (_btnOn) {
        if (contentSize.height >= 70) {
            
            self.topView.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, ff + contentSize.height - 70);
        }
    }else{
        self.topView.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, ff);
    }
    self.tableView.tableHeaderView.frame = self.topView.frame;

    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.topView];
    [self.tableView endUpdates];
}

- (void)baginToRead:(FourButtonView *)fourBtnView
{
    NSLog(@"点击了开始阅读");
    if (![self checkNetWork]) {
        [CommonMethod showMesg1:@"请连接网络!"];
        return;
    }

    NSString * isLock = [NSString stringWithFormat:@"%@",self.bookAllInfoDict[@"islock"]];
    
    if ([isLock isEqualToString:@"0"]) {
        //进入阅读
#pragma mark ==  加入 最近阅读
        [self addRecent];
        JrReaderViewController *jr = [[JrReaderViewController alloc]init:_bookAllInfoDict[@"novelName"] WithNovelId:_inovelId withCount:_bookAllInfoDict[@"maxChapterId"]];
        jr.delegate = self;

        NSString * collect =self.isCollertDict[@"status"];
        if (STRING_IS_NIL(collect)) {
            collect = @"no";
            
        }
        
        if ([collect isEqualToString:@"no"]) {
            jr.SELECT = YES;
        }else
            jr.SELECT = NO;
        [GlobalData getSharedInstance].novelName = _bookAllInfoDict[@"novelName"];
        [GlobalData getSharedInstance].novelCount = _bookAllInfoDict[@"maxChapterId"];
        [self.navigationController pushViewController:jr animated:YES];
 
        
    }else{
    
        [CommonMethod showMesg1:@"文章已被锁定!"];
    }
    
    
}
- (void)addRecent
{
    RecentReadManager *manager = [RecentReadManager shareManager];
    RecentReadModel *model = [[RecentReadModel alloc]init];
    model.novelId = _inovelId;
    model.novelName = _bookAllInfoDict[@"novelName"];
    model.novelIntro = _bookAllInfoDict[@"novelIntro"];
    model.cover = _bookAllInfoDict[@"novelCover"];
    model.authorName = _bookAllInfoDict[@"authorName"];
    model.chapterCount = _bookAllInfoDict[@"maxChapterId"];
    NSDate *datenow = [NSDate date];//现在时间
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    model.readStamp = timeSp;
    
    RecentReadModel *model1 = [[RecentReadModel alloc]init];
    model1 = [manager fetchModelWithNovelId:_inovelId];
    model.bookMarks = model1.bookMarks;
    [manager insertDataWithModel:model];
    BookshelfManager *shelfManager = [BookshelfManager shareManager];
    [shelfManager updateDataWithNovelId:_inovelId andTimeSp:timeSp];

}
//获取配置信息
-(NSString*)getPreference:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* value =  [defaults objectForKey:key];
    return value;
}
#pragma mark - LastChapterDelegate  //点击最新章节
- (void)lastChapterDelegateLast:(LastUpdateView *)lastUpView
{
    NSString * maxChapterId =self.bookAllInfoDict[@"maxChapterId"] ;
    if ([maxChapterId isEqualToString:@"0"]|| STRING_IS_NIL(maxChapterId)){
        [CommonMethod showMesg1:@"作者尚未上传任何文字或未通过快速审核!"];
        return;
    }
//加入最近阅读
    [self addRecent];
    JrReaderViewController *jr = [[JrReaderViewController alloc]init:_bookAllInfoDict[@"novelName"] WithNovelId:_inovelId withCount:_bookAllInfoDict[@"maxChapterId"]
                                                          withDEFINE:@"define"];
    jr.delegate = self;
    NSString * collect =self.isCollertDict[@"status"];
    if (STRING_IS_NIL(collect)) {
        collect = @"no";
        
    }
    if ([collect isEqualToString:@"no"]) {
        jr.SELECT = YES;
    }else
        jr.SELECT = NO;
    [GlobalData getSharedInstance].novelName = _bookAllInfoDict[@"novelName"];
    [GlobalData getSharedInstance].novelCount = _bookAllInfoDict[@"maxChapterId"];
    //章节
    [E_ReaderDataSource shareInstance].currentChapterIndex = 0;
    [self.navigationController pushViewController:jr animated:YES];
    
    [self performSelector:@selector(fox:) withObject:_bookAllInfoDict[@"renewChapterId"] afterDelay:0.1];
}
-(void)fox:(NSString *)cid{
    [self whatFoxSay:cid];
}
-(void)whatFoxSay:(NSString *)chapter{
    //发广播
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:chapter,@"BackData" ,nil];
    //设置广播内容
    [nc postNotificationName:@"BackData" object:nil userInfo:dic];
}
#pragma mark = LastDirectoryDelegate //点击 目录
- (void)lastDirectoryDelegateLast:(LastUpdateView *)lastUpView
{
    [self addRecent];
    bookmarkViewController *book = [[bookmarkViewController alloc]init:_inovelId withIname:_bookAllInfoDict[@"novelName"]];
    [GlobalData getSharedInstance].novelName = _bookAllInfoDict[@"novelName"];
    [GlobalData getSharedInstance].novelCount = _bookAllInfoDict[@"maxChapterId"];
    [self.navigationController pushViewController:book animated:YES];
}
- (void)downloadBook
{
    if ([[self getPreference:@"token"] length]<5)
    {
        [self temporaryAdd:NO];
    }
    downLoadViewController1 *down = [[downLoadViewController1 alloc]init:_inovelId WithNovelName:_bookAllInfoDict[@"novelName"]];
    [self.navigationController pushViewController:down animated:YES];

}
//键盘将要出现
- (void)keyboardWillShow:(NSNotification *)n
{
    self.cancelKeyboardBt.hidden = NO;

    NSDictionary* userInfo = [n userInfo];
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0];
    CGRect cgfFrame = self.cancelKeyboardBt.frame;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    cgfFrame.origin.y = (screenHeight - keyboardSize.height) - cgfFrame.size.height;
    self.cancelKeyboardBt.frame = cgfFrame;
    [UIView commitAnimations];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    replyView.hidden = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [replyView removeFromSuperview];
    self.cancelKeyboardBt.hidden = YES;
    [self.view endEditing:YES];
}
//键盘将要消失
-(void)keyboardWillHidden:(NSNotification*)n
{
    self.cancelKeyboardBt.hidden = YES;
    //根据键盘的情况坐标
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0];
    //修正取消按钮的矫正
    CGRect cgfFrame = self.cancelKeyboardBt.frame;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    cgfFrame.origin.y = (screenHeight - cgfFrame.size.height);
    self.cancelKeyboardBt.frame = cgfFrame;
    [UIView commitAnimations];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)refresh
{
    //请求footer header 数据
    [self initDataTopView];
    
    // 请求 tableView 数据
    [self initDataTableView];
    
}
@end
