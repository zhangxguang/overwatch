//
//  WMPageController.m
//  WMPageController
//
//  Created by Mark on 15/6/11.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMPageController.h"
#import "WMPageConst.h"
#import "HeroMessageViewController.h"
#import "HeroAbilitesTableController.h"
#import "HeroStoriesTableController.h"
#import "MBProgressHUD+MJ.h"
#import "HeroMessage.h"
#import "CollectionHeroFrame.h"

@interface WMPageController () <WMMenuViewDelegate,UIScrollViewDelegate> {
    CGFloat viewHeight;
    CGFloat viewWidth;
    CGFloat targetX;
    BOOL    animate;
}

@property (nonatomic, strong, readwrite) UIViewController *currentViewController;

@property (nonatomic, weak) WMMenuView *menuView;

@property (nonatomic, weak) UIScrollView *scrollView;

// 用于记录子控制器view的frame，用于 scrollView 上的展示的位置
@property (nonatomic, strong) NSMutableArray *childViewFrames;

// 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
@property (nonatomic, strong) NSMutableDictionary *displayVC;

// 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
@property (nonatomic, strong) NSMutableDictionary *posRecords;

// 用于缓存加载过的控制器
@property (nonatomic, strong) NSCache *memCache;

// 收到内存警告的次数
@property (nonatomic, assign) int memoryWarningCount;

@property (nonatomic, strong) NSMutableArray *CollectionHeroFrames;
//沙盒中存储收藏英雄的文件路径
@property (nonatomic, copy) NSString *filePath;
//从沙盒中取出来的英雄数据数组
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation WMPageController

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Lazy Loading
- (NSMutableDictionary *)posRecords {
    if (_posRecords == nil) {
        _posRecords = [[NSMutableDictionary alloc] init];
    }
    return _posRecords;
}

- (NSMutableDictionary *)displayVC {
    if (_displayVC == nil) {
        _displayVC = [[NSMutableDictionary alloc] init];
    }
    return _displayVC;
}

#pragma mark - Public Methods
- (instancetype)initWithViewControllerClasses:(NSArray *)classes andTheirTitles:(NSArray *)titles {
    if (self = [super init]) {
        NSAssert(classes.count == titles.count, @"classes.count != titles.count");
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];

        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setCachePolicy:(WMPageControllerCachePolicy)cachePolicy {
    _cachePolicy = cachePolicy;
    self.memCache.countLimit = _cachePolicy;
}

- (void)setItemsWidths:(NSArray *)itemsWidths {
    NSAssert(itemsWidths.count == self.titles.count, @"itemsWidths.count != self.titles.count");
    _itemsWidths = [itemsWidths copy];
}

- (void)setSelectIndex:(int)selectIndex {
    _selectIndex = selectIndex;
    if (self.menuView) {
        [self.menuView selectItemAtIndex:selectIndex];
    }
}

#pragma mark - Private Methods

// 当子控制器init完成时发送通知
- (void)postAddToSuperViewNotificationWithIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidAddToSuperViewNotification
                                                        object:info];
}

// 当子控制器完全展示在user面前时发送通知
- (void)postFullyDisplayedNotificationWithCurrentIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidFullyDisplayedNotification
                                                        object:info];
}

// 初始化一些参数，在init中调用
- (void)setup {
    _titleSizeSelected  = WMTitleSizeSelected;
    _titleColorSelected = WMTitleColorSelected;
    _titleSizeNormal    = WMTitleSizeNormal;
    _titleColorNormal   = WMTitleColorNormal;
    
    _menuBGColor   = WMMenuBGColor;
    _menuHeight    = WMMenuHeight;
    _menuItemWidth = WMMenuItemWidth;
    
    _memCache = [[NSCache alloc] init];
}

// 包括宽高，子控制器视图 frame
- (void)calculateSize {
    viewHeight = self.view.frame.size.height - self.menuHeight;
    viewWidth = self.view.frame.size.width;
    // 重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];
    for (int i = 0; i < self.viewControllerClasses.count; i++) {
        CGRect frame = CGRectMake(i*viewWidth, 0, viewWidth, viewHeight);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

#pragma mark - 设置scrollView.backgroundColor的背景图片
- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.pagingEnabled = YES;
    
    //设置背景图片
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overwatch.jpg"]];
    //iOS8开始用UIVisualEffectView实现毛玻璃效果
    UIView *visView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    CGFloat visViewX = self.view.bounds.origin.x;
    CGFloat visViewY = self.view.bounds.origin.y;
    CGFloat visViewW = self.view.bounds.size.width * 3;
    CGFloat visViewH = self.view.bounds.size.height;
    visView.frame = CGRectMake(visViewX, visViewY, visViewW, visViewH);
    //透明度，数值越大越模糊
    visView.alpha = 0.7;
    [scrollView addSubview:visView];
    
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addMenuView {
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight);
    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:self.titles backgroundColor:self.menuBGColor norSize:self.titleSizeNormal selSize:self.titleSizeSelected norColor:self.titleColorNormal selColor:self.titleColorSelected];
    menuView.delegate = self;
    menuView.style = self.menuViewStyle;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    [self.view addSubview:menuView];
    self.menuView = menuView;
    // 如果设置了初始选择的序号，那么选中该item
    if (self.selectIndex != 0) {
        [self.menuView selectItemAtIndex:self.selectIndex];
    }
}

- (void)layoutChildViewControllers {
    int currentPage = (int)self.scrollView.contentOffset.x / viewWidth;
    int start,end;
    if (currentPage == 0) {
        start = currentPage;
        end = currentPage + 1;
    } else if (currentPage + 1 == self.viewControllerClasses.count){
        start = currentPage - 1;
        end = currentPage;
    } else {
        start = currentPage - 1;
        end = currentPage + 1;
    }
    for (int i = start; i <= end; i++) {
        CGRect frame = [self.childViewFrames[i] CGRectValue];
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (vc == nil) {
                // 先从 cache 中取
                vc = [self.memCache objectForKey:@(i)];
                if (vc) {
                    // cache 中存在，添加到 scrollView 上，并放入display
                    [self addCachedViewController:vc atIndex:i];
                } else {
                    // cache 中也不存在，创建并添加到display
                    [self addViewControllerAtIndex:i];
                }
                [self postAddToSuperViewNotificationWithIndex:i];
            }
        } else {
            if (vc) {
                // vc不在视野中且存在，移除他
                [self removeViewController:vc atIndex:i];
            }
        }
    }
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
}

//  添加所有子控制器
- (void)addViewControllerAtIndex:(int)index {
    
    switch (index) {
        case 0:
        {
            HeroMessageViewController *viewController = [[HeroMessageViewController alloc] init];
            viewController.indexPath = self.indexPath;
            [self setUpOneChildViewController:viewController AtIndex:index];
        }
            break;
            
        case 1:
        {
            HeroAbilitesTableController *viewController = [[HeroAbilitesTableController alloc] init];
            viewController.indexPath = self.indexPath;
            [self setUpOneChildViewController:viewController AtIndex:index];
        }
            break;
            
        case 2:
        {
            HeroStoriesTableController *viewController = [[HeroStoriesTableController alloc] init];
            viewController.indexPath = self.indexPath;
            [self setUpOneChildViewController:viewController AtIndex:index];
        }
            break;
            
        default:
            break;
    }
}

//  添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)viewController AtIndex:(int)index
{
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
    
    [self backToPositionIfNeeded:viewController atIndex:index];
}

// 移除控制器，且从display中移除
- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self rememberPositionIfNeeded:viewController atIndex:index];
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayVC removeObjectForKey:@(index)];
    
    // 放入缓存
    if (![self.memCache objectForKey:@(index)]) {
        [self.memCache setObject:viewController forKey:@(index)];
    }
}

- (void)backToPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    if ([self.memCache objectForKey:@(index)]) return;
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        NSValue *pointValue = self.posRecords[@(index)];
        if (pointValue) {
            CGPoint pos = [pointValue CGPointValue];
            // 奇怪的现象，我发现 collectionView 的 contentSize 是 {0, 0};
            [scrollView setContentOffset:pos];
        }
    }
}

- (void)rememberPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        CGPoint pos = scrollView.contentOffset;
        self.posRecords[@(index)] = [NSValue valueWithCGPoint:pos];
    }
}

- (UIScrollView *)isKindOfScrollViewController:(UIViewController *)controller {
    UIScrollView *scrollView = nil;
    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        // Controller的view是scrollView的子类(UITableViewController/UIViewController替换view为scrollView)
        scrollView = (UIScrollView *)controller.view;
    } else if (controller.view.subviews.count >= 1) {
        // Controller的view的subViews[0]存在且是scrollView的子类，并且frame等与view得frame(UICollectionViewController/UIViewController添加UIScrollView)
        UIView *view = controller.view.subviews[0];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

- (BOOL)isInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    CGFloat ScreenWidth = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < ScreenWidth) {
        return YES;
    } else {
        return NO;
    }
}

- (void)resetMenuView {
    WMMenuView *oldMenuView = self.menuView;
    [self addMenuView];
    [oldMenuView removeFromSuperview];
}

- (void)growCachePolicyAfterMemoryWarning {
    self.cachePolicy = WMPageControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0];
}

- (void)growCachePolicyToHigh {
    self.cachePolicy = WMPageControllerCachePolicyHigh;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self addScrollView];
    [self addMenuView];
    
    [self addViewControllerAtIndex:self.selectIndex];
    
    //设置导航栏
    [self setupNavBar];
}

//plist转模型
- (NSArray *)CollectionHeroFrames
{
    if (_CollectionHeroFrames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HeroMessages.plist" ofType:nil];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *cfArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray) {
            HeroMessage *message = [HeroMessage messageWithDict:dict];
            
            CollectionHeroFrame *cf = [[CollectionHeroFrame alloc] init];
            cf.message = message;
            
            [cfArray addObject:cf];
        }
        _CollectionHeroFrames = cfArray;
    }
    return _CollectionHeroFrames;
}

#pragma mark 设置导航栏按钮
//设置导航栏
- (void)setupNavBar
{
    //读取数据
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"herodata.plist"];
    self.filePath = filePath;
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:self.filePath];
    self.data = data;
    //取出当前英雄的数据
    CollectionHeroFrame *messageFrame = self.CollectionHeroFrames[self.indexPath.row];
    
    for (NSString *name in self.data) {
        if ([name isEqualToString:messageFrame.message.name]) {
            //替换右边按钮 黄色
            UIButton *button = [self setupButtonWithImageNmaeL:@"toolbar_unfavorite_highlighted" highlightedImageName:@"toolbar_unfavorite"];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            return;
        }
    }
    //设置右边按钮 灰色
    UIButton *button = [self setupButtonWithImageNmaeL:@"toolbar_unfavorite" highlightedImageName:@"toolbar_unfavorite_highlighted"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//设置按钮
- (UIButton *)setupButtonWithImageNmaeL:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:self action:@selector(Collection) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//点击rightBarButton时调用
- (void)Collection
{
    //取出当前英雄的数据
    CollectionHeroFrame *messageFrame = self.CollectionHeroFrames[self.indexPath.row];
    
    //遍历数组中的数据
    for (NSString *name in self.data) {
        //如果英雄名字相同就让按钮变成灰色，同时删除数组中的相同值
        if ([name isEqualToString:messageFrame.message.name]) {
            // 显示一个蒙版(遮盖)
            [MBProgressHUD showMessage:@"已从收藏中删除"];
            
            //替换右边按钮 灰色
            UIButton *button = [self setupButtonWithImageNmaeL:@"toolbar_unfavorite" highlightedImageName:@"toolbar_unfavorite_highlighted"];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            //删除数组中的相同的名字
            [self.data removeObject:name];
            //将数组存入文件
            [self.data writeToFile:self.filePath atomically:YES];
            //0.5秒后移除遮盖
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除遮盖
                [MBProgressHUD hideHUD];
            });
            return;
        }
    }
    
    // 显示一个蒙版(遮盖)
    [MBProgressHUD showMessage:@"已收藏"];
    
    //如果数组中没有相同值，就把按钮变成黄色，并且把这个值加入数组
    //替换右边按钮  黄色
    UIButton *button = [self setupButtonWithImageNmaeL:@"toolbar_unfavorite_highlighted" highlightedImageName:@"toolbar_unfavorite"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //存入数组
    [self.data addObject:messageFrame.message.name];
    //存入文件
    [self.data writeToFile:self.filePath atomically:YES];
    //0.5秒后移除遮盖
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 移除遮盖
        [MBProgressHUD hideHUD];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 计算宽高及子控制器的视图frame
    [self calculateSize];
    CGRect scrollFrame = CGRectMake(0, self.menuHeight, viewWidth, viewHeight);
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeMake(self.titles.count*viewWidth, viewHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectIndex*viewWidth, 0)];

    self.currentViewController.view.frame = [self.childViewFrames[self.selectIndex] CGRectValue];
    
    [self resetMenuView];

    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.memoryWarningCount++;
    self.cachePolicy = WMPageControllerCachePolicyLowMemory;
    // 取消正在增长的 cache 操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    
    [self.memCache removeAllObjects];
    [self.posRecords removeAllObjects];
    self.posRecords = nil;
    
    // 如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
    if (self.memoryWarningCount < 3) {
        [self performSelector:@selector(growCachePolicyAfterMemoryWarning) withObject:nil afterDelay:3.0];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutChildViewControllers];
    if (animate) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        CGFloat rate = contentOffsetX / viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / viewWidth;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = targetX / viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    targetX = targetContentOffset->x;
}

#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    animate = NO;
    CGPoint targetP = CGPointMake(viewWidth*index, 0);
    
    [self.scrollView setContentOffset:targetP animated:gap > 1?NO:self.pageAnimatable];
    if (gap > 1 || !self.pageAnimatable) {
        [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
        // 由于不触发 -scrollViewDidScroll: 手动清除控制器..
        UIViewController *vc = [self.displayVC objectForKey:@(currentIndex)];
        if (vc) {
            [self removeViewController:vc atIndex:currentIndex];
        }
    }
    _selectIndex = (int)index;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.itemsWidths) {
        return [self.itemsWidths[index] floatValue];
    }
    return self.menuItemWidth;
}

@end
