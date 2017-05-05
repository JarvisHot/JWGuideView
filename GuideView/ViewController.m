//
//  ViewController.m
//  GuideView
//
//  Created by jiang on 2017/5/2.
//  Copyright © 2017年 jiang. All rights reserved.
//

#import "ViewController.h"
#import "JWGuideView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image1 = [UIImage imageNamed:@"引导页1"];
    UIImage * image2 = [UIImage imageNamed:@"引导页2"];
    UIImage * image3 = [UIImage imageNamed:@"引导页3"];
    UIImage * image4 = [UIImage imageNamed:@"引导页4"];
    UIImage * image5 = [UIImage imageNamed:@"引导页5"];
    JWGuideView*guide=[JWGuideView guideViewWithFrame:[UIScreen mainScreen].bounds images:@[image1,image2,image3,image4,image5] timeInterVal:0 didScroll:^(NSInteger Index) {
        NSLog(@"index-----%ld",Index);
    }pageControlEnable:YES pageIndicatorColor:[UIColor whiteColor] currentPageColor:[UIColor greenColor]];
    [self.view addSubview:guide];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
