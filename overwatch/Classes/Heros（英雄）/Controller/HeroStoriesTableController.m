//
//  HeroStoriesTableController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroStoriesTableController.h"
#import "HeroStories.h"
#import "HeroStoriesFrame.h"
#import "HeroStoriesTableViewCell.h"
#import "MJExtension.h"

@interface HeroStoriesTableController ()
@property (nonatomic, strong) NSMutableArray *StoriesFrame;
@end

@implementation HeroStoriesTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滚动条为白色
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.view.backgroundColor = [UIColor clearColor];
}

- (NSMutableArray *)StoriesFrame
{
    if (_StoriesFrame == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HeroStory.plist" ofType:nil];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *sfArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray[self.indexPath.row]) {
            HeroStories *stories = [HeroStories storyWithDict:dict];
            
            HeroStoriesFrame *sf = [[HeroStoriesFrame alloc] init];
            sf.stories = stories;
            
            [sfArray addObject:sf];
        }
        _StoriesFrame = sfArray;
    }
    return _StoriesFrame;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.StoriesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeroStoriesTableViewCell *cell = [HeroStoriesTableViewCell cellWithTableView:tableView];
    //使cell无法被点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.storiesFrame = self.StoriesFrame[indexPath.row];
    
    return cell;
}

#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeroStoriesFrame *sf = self.StoriesFrame[indexPath.row];
    
    return sf.cellHeight;
}

@end
