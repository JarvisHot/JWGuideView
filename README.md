# JWGuideView
### 简单的新手引导页
```
    UIImage * image1 = [UIImage imageNamed:@"引导页1"];
    UIImage * image2 = [UIImage imageNamed:@"引导页2"];
    UIImage * image3 = [UIImage imageNamed:@"引导页3"];
    UIImage * image4 = [UIImage imageNamed:@"引导页4"];
    UIImage * image5 = [UIImage imageNamed:@"引导页5"];
    JWGuideView*guide=[JWGuideView guideViewWithFrame:[UIScreen mainScreen].bounds     images:@[image1,image2,image3,image4,image5] timeInterVal:0 didScroll:^(NSInteger Index) {
        NSLog(@"index-----%ld",Index);
    }pageControlEnable:YES pageIndicatorColor:[UIColor whiteColor] currentPageColor:[UIColor greenColor]];
    [self.view addSubview:guide];
  ```
  
