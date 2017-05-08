//
//  JWGuideView.m
//  GuideView
//
//  Created by jiang on 2017/5/2.
//  Copyright © 2017年 jiang. All rights reserved.
//
#define SCREEN_Width   [UIScreen mainScreen].bounds.size.width
#define SCREEN_Height   [UIScreen mainScreen].bounds.size.height
#import "JWGuideView.h"
@interface JWGuideView()<UIScrollViewDelegate>
{
    UIPageControl*_pageControl;
    UIScrollView*_backScrollView;
    UIButton*_experienceNow;
    NSTimeInterval _lastClickTime;
}
@property (nonatomic, assign) CFRunLoopTimerRef timer;
@property (nonatomic, assign) NSInteger previousPageIndex;
@property(nonatomic,assign)BOOL pageControlEnable;
@property(nonatomic,retain)UIColor* indicatorColor;
@property(nonatomic,retain)UIColor*currentPageColor;
@end
@implementation JWGuideView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+(instancetype)guideViewWithFrame:(CGRect)frame
                           images:(NSArray<UIImage *>*)images
                     timeInterVal:(NSTimeInterval)timeInterval
                pageControlEnable:(BOOL)pageControlEnable
               pageIndicatorColor:(UIColor*)indicatorColor
                 currentPageColor:(UIColor*)currentPageColor
                        didScroll:(JWScrollViewDidScrollBlock)didScroll
           didCLickSkipToMainPage:(JWClickBlock)didGoToMain
{
    JWGuideView*guide=[[JWGuideView alloc]initWithFrame:frame];
    guide.timeInterval=timeInterval;
    guide.images=images;
    guide.didScroll = didScroll;
    guide.didGoToMain =didGoToMain;
    guide.pageControlEnable=pageControlEnable;
    guide.indicatorColor=indicatorColor;
    guide.currentPageColor=currentPageColor;
    return guide;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self configScrollAndPageControl:frame];
    }
    return self;
}
-(void)setPageControlEnable:(BOOL)pageControlEnable
{
    _pageControlEnable=pageControlEnable;
    if (!_pageControlEnable) {
        _pageControl.hidden=YES;
    }
}
-(void)setIndicatorColor:(UIColor *)indicatorColor
{
    if (indicatorColor==nil) {
        return;
    }
    _indicatorColor=indicatorColor;
    _pageControl.pageIndicatorTintColor=_indicatorColor;
    
}
-(void)setCurrentPageColor:(UIColor *)currentPageColor
{
    if (currentPageColor==nil) {
        return;
    }
    _currentPageColor=currentPageColor;
    _pageControl.currentPageIndicatorTintColor=_currentPageColor;
}

-(void)setImages:(NSArray<UIImage *> *)images
{
    if (![images isKindOfClass:[NSArray class]]) {
        return;
    }
    if (images==nil||images.count==0) {
        [self pauseTimer];
        
        _backScrollView.scrollEnabled=NO;
    }
    if (_images!=images) {
        _images=images;
    }
    _backScrollView.contentSize=CGSizeMake(images.count*self.bounds.size.width, self.bounds.size.height);
    
    for (int i=0; i<images.count; i++) {
        UIImage*img=images[i];
        UIImageView*imgV=[[UIImageView alloc]initWithImage:img];
        imgV.frame=CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height);
        [_backScrollView addSubview:imgV];
        if (i==images.count-1) {
            _experienceNow.frame=CGRectMake(self.bounds.size.width*i+self.bounds.size.width/2-100, self.bounds.size.height-130, 200, 50);
        }
    }
    _pageControl.numberOfPages=images.count;
    _pageControl.hidesForSinglePage=YES;
    [self bringSubviewToFront:_pageControl];
    [_backScrollView bringSubviewToFront:_experienceNow];
    if (images.count>1) {
        
        _backScrollView.scrollEnabled=YES;
        [self startTimer];
    }else{
        [self pauseTimer];
    }
}
-(void)configScrollAndPageControl:(CGRect)frame
{
    _backScrollView=[[UIScrollView alloc]initWithFrame:frame];
    _backScrollView.pagingEnabled=YES;
    _backScrollView.bounces=NO;
    _backScrollView.delegate=self;
    [self addSubview:_backScrollView];
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(frame.size.width/2-100, frame.size.height-80, 200, 30)];
    [self addSubview:_pageControl];
    _experienceNow=[[UIButton alloc]init];
    [_experienceNow addTarget:self action:@selector(skipToMainPage) forControlEvents:UIControlEventTouchUpInside];
    _experienceNow.layer.borderWidth=1;
    _experienceNow.layer.borderColor=[UIColor whiteColor].CGColor;
    _experienceNow.layer.cornerRadius=8;
    _experienceNow.layer.masksToBounds=YES;
    [_experienceNow setTitle:@"立即体验" forState:UIControlStateNormal];
    [_backScrollView addSubview:_experienceNow];
}
-(void)pauseTimer
{
    if (self.timer) {
        CFRunLoopTimerInvalidate(self.timer);
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
    }
}

-(void)startTimer
{
    if (self.images.count<=1) {
        return;
    }
    if (self.timer) {
        CFRunLoopTimerInvalidate(self.timer);
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
    }
    __weak __typeof(self) weakSelf = self;
    CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + _timeInterval, _timeInterval, 0, 0, ^(CFRunLoopTimerRef timer) {
        [weakSelf autoScroll];
    });
    self.timer=timer;
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
}
-(void)autoScroll
{
    if (self.previousPageIndex==self.images.count-1||self.timeInterval==0) {
        return;
    }
    [_backScrollView setContentOffset:CGPointMake((self.previousPageIndex+1)*self.bounds.size.width, 0) animated:YES];
}
#pragma mark -------UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.previousPageIndex=_backScrollView.contentOffset.x/self.frame.size.width;
    _pageControl.currentPage=_previousPageIndex;
    CGFloat offset=_backScrollView.contentOffset.x/self.frame.size.width;
    if (offset>_images.count-2) {
        _pageControl.hidden=YES;
    }else{
        _pageControl.hidden=NO;
    }
    
    CGFloat x =scrollView.contentOffset.x-self.frame.size.width;
    NSUInteger index=fabs(x)/self.frame.size.width;
    CGFloat findex=fabs(x)/self.frame.size.width;
    
    if (self.didScroll&& fabs(findex-(CGFloat)index)<=0.00001) {
        self.didScroll(self.previousPageIndex);
    }
}
-(void)skipToMainPage
{
    NSTimeInterval frequencyTimestamp = 0.75;
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    if ( now - _lastClickTime > frequencyTimestamp) {
        _lastClickTime = now;
//        NSLog(@"didclick experienceNow methodCall");
        if (self.didGoToMain) {
            self.didGoToMain();
        }
        
    }
}

@end
