//
//  JWGuideView.h
//  GuideView
//
//  Created by jiang on 2017/5/2.
//  Copyright © 2017年 jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JWScrollViewDidScrollBlock)(NSInteger Index);
@interface JWGuideView : UIView
@property(nonatomic,strong)NSArray<UIImage*>*images;
@property(nonatomic,assign)NSTimeInterval timeInterval;
@property(nonatomic,copy)JWScrollViewDidScrollBlock didScroll;
/*
 初始化引导页
 timeInterval 传 0 时 timer不可用
 didScroll 滚动block
 pageControlEnable 是否显示pageControl
 indicatorColor 默认pageControl颜色
 currentPageColor 当前选中页的颜色
 
 */
+(instancetype)guideViewWithFrame:(CGRect)frame
                           images:(NSArray<UIImage *>*)images
                     timeInterVal:(NSTimeInterval)timeInterval
                        didScroll:(JWScrollViewDidScrollBlock)didScroll
                pageControlEnable:(BOOL)pageControlEnable
               pageIndicatorColor:(UIColor*)indicatorColor
                 currentPageColor:(UIColor*)currentPageColor;

/*
 暂停或停止定时器
 */
-(void)pauseTimer;

/*
 开启定时器
 */
-(void)startTimer;
@end
