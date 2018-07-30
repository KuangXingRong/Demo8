//
//  KPlayerView.m
//  Demo7
//
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KPlayerView.h"
#import <AVFoundation/AVFoundation.h>

#define DefaultShowTime 5.0f

@interface KPlayerView ()<UIGestureRecognizerDelegate>

//播放API
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) id timeObserver;

//UI
@property (nonatomic, strong) UIView *statusBar;
@property (nonatomic, strong) UIView *bottomTool;
@property (nonatomic, strong) UIImageView *switchPlay, *switchScreen;
@property (nonatomic, strong) UISlider *progressSlider;
@property(nonatomic, strong) UILabel *currentTime, *totalTime, *internetSpeed;
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

//状态
@property(nonatomic, assign) BOOL fullScreen;
@property(nonatomic, assign) BOOL hiddenSubview;
@property(nonatomic, assign) BOOL internetSpeedStop;
@property(nonatomic, assign) NSInteger currentTimeRange;
@property(nonatomic, assign) CGFloat showTime;

//记录初始化时的状态
@property(nonatomic, assign) BOOL hidenNavigationBar;
@property(nonatomic, assign) BOOL statusBarHidden;
@property(nonatomic, assign) CGRect firstFrame;



@end


@implementation KPlayerView


#pragma mark - 初始化控件相关
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.blackColor;
        self.clipsToBounds = YES;
        self.fullScreen = NO;
        self.hiddenSubview = NO;
        self.showTime = DefaultShowTime;

        self.statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        self.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;

        self.hidenNavigationBar = self.findViewController.navigationController.isNavigationBarHidden;

        self.firstFrame = self.frame;



        WEAK(weakSelf, self)
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGetsureHander:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        [self addClick:^(id view) {
            [weakSelf setHiddenSubview:!weakSelf.hiddenSubview];
            weakSelf.showTime = weakSelf.hiddenSubview ? 0.0f : DefaultShowTime;
        }];



        self.bottomTool = [self addViewWithsize:CGSizeMake(SCREEN_WIDTH, 50)];
        [self.bottomTool addClick:nil];

        self.switchScreen = [_bottomTool addImg:Frame(0, 0, X(28), X(28)) image:[UIImage imageNamed:@"player_fullScreen"]];
        [self.switchScreen addClick:^(id view) {
            weakSelf.fullScreen = !weakSelf.fullScreen;
        }];

        self.switchPlay = [_bottomTool addImg:Frame(0, 0, X(35), X(35)) image:[UIImage imageNamed:@"player_start"]];
        [self.switchPlay addClick:^(UIView *view) {
            weakSelf.showTime = DefaultShowTime;
            [weakSelf playOrPause];
            weakSelf.switchPlay.image = [UIImage imageNamed:view.tag != 100 ? @"player_start" : @"player_pause"];
        }];

        self.currentTime = [_bottomTool addLab:@"00:00" fontSize:13 color:0xFFFFFF maxWidth:100];

        self.totalTime = [_bottomTool addLab:@"00:00" fontSize:13 color:0xFFFFFF maxWidth:100];

        self.progressSlider = [[UISlider alloc] initWithFrame:Frame(0, 0, SCREEN_WIDTH - X(100), 40)];
        [_bottomTool addSubview:self.progressSlider];
        [self.progressSlider setThumbImage:[UIImage imageNamed:@"icmpv_thumb_light"] forState:UIControlStateNormal];
        [self.progressSlider addTarget:self action:@selector(progressDragEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
        [self.progressSlider addTarget:self action:@selector(progressDraging:) forControlEvents:UIControlEventValueChanged];


        self.internetSpeed = [self addLab:@"0.0kb/s" fontSize:13 color:0xFFFFFF maxWidth:200];
        self.internetSpeed.width = 200;
        self.internetSpeed.textAlignment = NSTextAlignmentCenter;

    }
    
    return self;
}

-(void)setDelegate:(id<KPlayerViewDelegate>)delegate{
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(playerView:addSubviewTBottomTool:)]) {
        [_delegate playerView:self addSubviewTBottomTool:_bottomTool];
        for (UIView *subView in self.subviews) {
            [self bringSubviewToFront:subView];
            
        }
    }
}

#pragma mark - 全屏切换相关
- (void)setFullScreen:(BOOL)fullScreen{
    if (_fullScreen == fullScreen) {
        return;
    }
    UIViewController *vc = self.findViewController;
    if (fullScreen) {
        
        if (vc.navigationController && !vc.navigationController.isNavigationBarHidden) {
            [vc.navigationController setNavigationBarHidden:YES animated:NO];
            //self.top = kNavigationBarHeight;
        }
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }else{
        
        [vc.navigationController setNavigationBarHidden:!self.hidenNavigationBar animated:NO];
        
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        
    }
}

// 横竖屏适配
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    self.showTime = DefaultShowTime;
    NSString *imgstr = self.fullScreen ? @"player_window" : @"player_fullScreen";
    self.switchScreen.image = [UIImage imageNamed:imgstr];
    
    
    [super traitCollectionDidChange:previousTraitCollection];
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) { // 转至竖屏
        _fullScreen = NO;
        self.frame = self.firstFrame;
        [self resetFrame:NO];
    } else if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) { // 转至横屏
        _fullScreen = YES;
        self.frame = Frame(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self resetFrame:YES];
    }
}

// 根据方向改变状态栏的风格
- (void)changeStatusBarStyle:(NSNotification *)note
{
    UIInterfaceOrientation statusOrientation = [note.userInfo[@"UIApplicationStatusBarOrientationUserInfoKey"] integerValue];
    if (statusOrientation == UIInterfaceOrientationPortrait) {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = self.statusBarStyle;
    }
}


//重置布局
- (void)resetFrame:(BOOL) fullScreen{
    [self.superview bringSubviewToFront:self];
    
    self.playerLayer.frame = self.bounds;
    self.bottomTool.width = self.width;
    self.bottomTool.bottom = self.height;
    
    
//    self.switchPlay.left = fullScreen ? kTopBarSafeHeight : 10;
    self.switchPlay.left =  10;
    self.switchPlay.bottom = _bottomTool.height - 5;
    
    
//    self.switchScreen.right = _bottomTool.width - (fullScreen ? kBottomSafeHeight : 10);
    self.switchScreen.right = _bottomTool.width - 10;
    self.switchScreen.centerY = _switchPlay.centerY;
    
    
    self.currentTime.left = _switchPlay.right + 10;
    self.currentTime.centerY = _switchPlay.centerY;
    
    self.totalTime.right = _switchScreen.left - 10;
    self.totalTime.centerY = _switchPlay.centerY;
    
    self.progressSlider.width = _totalTime.left - 10 - _currentTime.right - 10;
    self.progressSlider.left = _currentTime.right + 10;
    self.progressSlider.centerY = _switchPlay.centerY;
    
    self.internetSpeed.center = CGPointMake(self.width /2, self.height /2);
    
    
    [self viewWithTag:666].center = CGPointMake(self.width /2, self.height /2);
//
    [self viewWithTag:667].center = CGPointMake(self.width /2, self.height /2);
    
    if ([self.delegate respondsToSelector:@selector(playerView:resetFrame:)]) {
        [self.delegate playerView:self resetFrame:_fullScreen];
    }
}
#pragma mark - 自动隐藏相关
- (void)setHiddenSubview:(BOOL)hiddenSubview{
    _hiddenSubview = hiddenSubview;
    if (hiddenSubview) {
        for (UIView *subView in self.subviews) {
            if (subView == self.bottomTool) {
                [UIView animateWithDuration:0.5 animations:^{
                    subView.top += self.height - subView.top;
                    self.statusBar.alpha = 0.0f;
                }];
            }else if (subView == self.internetSpeed) {
                continue;
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    subView.alpha = 0.0f;
                }];
            }
          
        }
        
    }else{
        for (UIView *subView in self.subviews) {
            if (subView == self.bottomTool) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self resetFrame:self.fullScreen];
                    self.statusBar.alpha = 1.0f;
                }];
            }else if (subView == self.internetSpeed) {
                continue;
            }else {
                [UIView animateWithDuration:0.5 animations:^{
                    subView.alpha = 1.0f;
                }];
            }
        }
        
    }
}

-(void)setShowTime:(CGFloat)showTime{
    _showTime = showTime;
    if (showTime <= 0) {
        [self setHiddenSubview:YES];
    }
}
#pragma mark - 手势
- (void)panGetsureHander:(UIPanGestureRecognizer*) gesture{
    CGPoint pt = [gesture translationInView:self];
    if (pt.x > 10 && pt.x > pt.y) {
        
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self; //解决手势冲突问题
}

#pragma mark - 播放相关
- (void)playWithURL:(NSURL *) url{
    // 重置player
    [self resetPlayer];
    
    
    // 因为replaceCurrentItemWithPlayerItem在使用时会卡住主线程 重新创建player解决
    self.player = [self setupPlayer];
    self.asset = [AVURLAsset assetWithURL:url];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    
    
//    // 添加时间周期OB、OB和通知
    [self addTimerObserver];
    [self addPlayItemObserverAndNotification];
    
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
}


// 创建播放器
- (AVPlayer *)setupPlayer
{
    AVPlayer *player = [[AVPlayer alloc] init];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.layer addSublayer:playerLayer];
    self.playerLayer = playerLayer;
    self.playerLayer.frame = self.bounds;
    for (UIView *subView in self.subviews) {
        [self bringSubviewToFront:subView];

    }
    return player;
}

// 重置播放器
- (void)resetPlayer
{
    [self removePlayItemObserverAndNotification];
    [self removeTimeObserver];
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.asset = nil;
    self.playerItem = nil;
    self.player = nil;
}


// 播放或暂停
- (void)playOrPause
{
    if (self.switchPlay.tag == 200) { //播放
        self.switchPlay.tag = 100;
        [self.player play];
    } else if (self.switchPlay.tag == 100) { //暂停
        self.switchPlay.tag = 200;
        [self.player pause];
    }else if(self.switchPlay.tag == 300){ //重播
        self.switchPlay.tag = 200;
        self.progressSlider.value = 0;
        [self progressDraging:_progressSlider];
        [self progressDragEnd:_progressSlider];
        
    }
}

// 拖拽进度条
- (void)progressDraging:(UISlider *)slider
{
    self.showTime = DefaultShowTime;
    if (self.switchPlay.tag != 200) {
        [self playOrPause];
    }
    NSLog(@"time:%@", [self stringWithTime:self.progressSlider.value]);
    [self.currentTime setString:[self stringWithTime:self.progressSlider.value]];
}


// 进度条拖拽结束
- (void)progressDragEnd:(UISlider *)slider
{
    self.showTime = DefaultShowTime;
    [self.player seekToTime:CMTimeMake(self.progressSlider.value, 1.0)];
    [self playOrPause];
    self.switchPlay.image = [UIImage imageNamed: @"player_pause"];
//    // 延迟10.0秒后隐藏播放控制面板
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self hideControlPanel];
//        [self hideStatusBar];
//    });
}



// 给进度条Slider添加时间OB
- (void)addTimerObserver
{
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (weakSelf.showTime > 0) {
            weakSelf.showTime -= 1;
        }
        
//        weakSelf.currentTimeLabel.text = [weakSelf stringWithTime:CMTimeGetSeconds(weakSelf.player.currentTime)];
//        NSLog(@"currentTime: %@", [weakSelf stringWithTime:CMTimeGetSeconds(weakSelf.player.currentTime)]) ;
        [weakSelf.currentTime setString:[weakSelf stringWithTime:CMTimeGetSeconds(weakSelf.player.currentTime)]];
        
        weakSelf.progressSlider.value = CMTimeGetSeconds(weakSelf.player.currentTime);
    }];
}

- (NSString *)stringWithTime:(CGFloat)time;
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    if (time >= 3600) {
        [dateFmt setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFmt setDateFormat:@"mm:ss"];
    }
    return [dateFmt stringFromDate:date];
}

// 移除时间OB
- (void)removeTimeObserver
{
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}


// 给playItem添加观察者KVO
- (void)addPlayItemObserverAndNotification
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:NULL];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:NULL];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBarStyle:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
// KVO检测播放器各种状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playItem = (AVPlayerItem *)object;
    NSTimeInterval totalTime = CMTimeGetSeconds(self.asset.duration);
    if ([keyPath isEqualToString:@"status"]) { // 检测播放器状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) { // 达到能播放的状态
            self.switchPlay.tag = 200;
            [self.totalTime setString:[self stringWithTime:totalTime]];
            self.progressSlider.maximumValue = totalTime;
        } else if (status == AVPlayerStatusFailed) { // 播放错误 资源不存在 网络问题等等
            UILabel *hintLabel = [self addLab:@"资源不存在..." fontSize:13 color:0xFFFFFF maxWidth:200];
            hintLabel.tag = 666;
            hintLabel.center = CGPointMake(self.width /2, self.height / 2);
            self.internetSpeedStop = YES;
            self.internetSpeed.hidden = YES;
            
        } else if (status == AVPlayerStatusUnknown) { // 未知错误
            UILabel *hintLabel = [self addLab:@"网络错误，请检查手机网络..." fontSize:13 color:0xFFFFFF maxWidth:200];
            hintLabel.tag = 667;
            hintLabel.center = CGPointMake(self.width /2, self.height / 2);
            self.internetSpeedStop = YES;
            self.internetSpeed.hidden = YES;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) { // 检测缓存状态
       
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {  // 缓存为空

        if (playItem.playbackBufferEmpty) {
            NSLog(@"缓存为空");

        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) { // 缓存足够能播放
       
        if (playItem.playbackLikelyToKeepUp) {
            NSLog(@"缓存足够能播放");
            self.internetSpeed.hidden = YES;
            if (self.switchPlay.tag == 100) {
                [self.player play];
            }
        }
    }else if ([keyPath isEqualToString:@"timeControlStatus"]){
        
        if (@available(iOS 10.0, *)) {
            if (self.player.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
                
                self.internetSpeed.hidden = NO;
                [self bringSubviewToFront:self.internetSpeed];
                
              
            }else  if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
                self.internetSpeed.hidden = YES;
            }
        }else{
            self.internetSpeed.hidden = YES;
        }
       
    }

}

// KVO监测到播放完调用
- (void)playFinished:(NSNotification *)note{
    [self setHiddenSubview:NO];
    self.showTime = DefaultShowTime;
    self.switchPlay.image = [UIImage imageNamed:@"replay"];
    self.switchPlay.tag = 300;
}

// 移除观察者和通知
- (void)removePlayItemObserverAndNotification
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"timeControlStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}



-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        self.internetSpeedStop = NO;
        [self updateInternetSpeed];
    }else{
        self.internetSpeedStop = YES;
    }
}

//自动更新当前网速信息
- (void)updateInternetSpeed{
    if (!self.internetSpeedStop) {
        [self performSelector:@selector(updateInternetSpeed) withObject:nil afterDelay:1];
    }
    if (self.playerItem && (!self.internetSpeedStop)) {
        NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        NSTimeInterval bufferingTime = CMTimeGetSeconds(timeRange.duration);
        
        if (self.currentTimeRange == bufferingTime) {
            self.internetSpeed.text = [NSString stringWithFormat:@"0.0kb/s"];
            return;
        }
        self.currentTimeRange = bufferingTime;
        self.internetSpeed.text = [NSString stringWithFormat:@"%.2fkb/s", ABS(bufferingTime)];
    }
}

- (void)dealloc{
    [self removePlayItemObserverAndNotification];
    [self removeTimeObserver];
}




@end

#pragma mark - 使用
@implementation UIView(UIView_KPlayerView)

- (KPlayerView*) addKPlayerView:(CGRect) frame{
    KPlayerView *pv = [[KPlayerView alloc] initWithFrame:frame];
    [self addSubview:pv];
    return pv;
}
@end
