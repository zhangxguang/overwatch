//
//  HeroMessageViewController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/24.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroMessageViewController.h"
#import "HeroMessage.h"
#import "HeroMessageFrame.h"
#import "HeroMessageView.h"
#import "WMPageController.h"

@interface HeroMessageViewController ()
@property (nonatomic, strong) NSArray *HeromessageFrames;
@end

@implementation HeroMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setupView];
}

- (void)setupView
{
    HeroMessageView *view = [[HeroMessageView alloc] initWithFrame:self.view.frame];
    view.messageFrame = self.HeromessageFrames[self.indexPath.row];
    [self.view addSubview:view];
}

- (NSArray *)HeromessageFrames
{
    if (_HeromessageFrames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HeroMessages.plist" ofType:nil];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *mfArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray) {
            HeroMessage *messages = [HeroMessage messageWithDict:dict];
            
            HeroMessageFrame *mf = [[HeroMessageFrame alloc] init];
            mf.message = messages;
            
            [mfArray addObject:mf];
        }
        _HeromessageFrames = mfArray;
    }
    return _HeromessageFrames;
}

@end
