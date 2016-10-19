//
//  ViewController.m
//  PictureCarousel
//
//  Created by MichaelLi on 2016/10/18.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) NSTimer *timer;
@end
@implementation ViewController
static  int imageCount = 5;

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置scrollView
    [self setScrollViewUI];
    //设置pageControl
    [self setPageControlUI];
    self.scrollView.delegate = self;

    [self setScrollTimer];

}

-(void) setScrollViewUI {
    for (int i = 0; i <imageCount ; i++) {
        //设置X:随着i不断增加
        CGFloat x = self.scrollView.frame.size.width*i;
        //设置imageViewframe
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        NSString *imageNamed = [NSString stringWithFormat:@"img_%02d",i+1];
        //设置imageView上的image
        imageView.image = [UIImage imageNamed:imageNamed];
        [self.scrollView addSubview:imageView];
    }
    //scrollView 滚动范围
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*imageCount, 0);

    //取消水平线
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

-(void)setPageControlUI
{
    self.scrollView.pagingEnabled = YES;
    //设置pageControl数量
    self.pageControl.numberOfPages = imageCount;
    //设置pageControl的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.currentPage = 0;
}
#pragma mark
#pragma mark -  拖拽完成
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置pageControl当前数:scrollView 偏移量/宽
    self.pageControl.currentPage = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    NSLog(@"%ld",(long)self.pageControl.currentPage);
}
#pragma mark
#pragma mark -  点击自动滚动
- (IBAction)scrollButtton:(UIButton *)sender {
    /*
     每点击一次,就自动滚动一下
     1.改变了scrollView.contentOfset
     2.pageControl.currentPage
     */
    if (self.pageControl.currentPage == 4) {
        //再次点击,返回到初始界面
        self.pageControl.currentPage = 0;
        self.scrollView.contentOffset = CGPointZero;
    }else {

        //取出当前scrollView.contentOffset
        CGPoint offset = self.scrollView.contentOffset;
        offset.x += self.scrollView.frame.size.width;
        //取出当前的pageControl
        NSInteger currentPage =  self.pageControl.currentPage;
        currentPage += 1;
        self.pageControl.currentPage = currentPage;
        [self.scrollView setContentOffset:offset animated:YES];
        NSLog(@"offset.x%f",offset.x);
    }

}
#pragma mark
#pragma mark -  设置计时器
-(void)setScrollTimer
{
    //计时器:3s后,直接调用点击按钮
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollButtton:) userInfo:nil repeats:YES];

    //手指拖拽text时,scrollView不会滚动,因为优先级的原因
    //更改优先级---可以滚动
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    //仍旧不可以滚动
//    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
#pragma mark
#pragma mark -  手指拖拽时,计时器无效
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
#pragma mark
#pragma mark -  拖拽停止时,计时器有效
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [self.timer fire];//无效,一旦设置invalidate,重新打开计时器需要重新调用

    [self setScrollTimer];
}
@end
