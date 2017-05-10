//
//  VLCVideoViewController.m
//  JSVLCDemo
//
//  Created by ShengWang Gao on 2017/5/9.
//  Copyright © 2017年 ShengWang Gao. All rights reserved.
//

#import "JSVLCVideoViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import <AVFoundation/AVFoundation.h>

@interface JSVLCVideoViewController ()<VLCMediaPlayerDelegate, VLCMediaThumbnailerDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) VLCMediaPlayer *player;
@property (strong, nonatomic) VLCMediaThumbnailer *mediaThumbnailer;

@end

@implementation JSVLCVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playButton setTitle:@"暂停" forState:UIControlStateSelected];
    
    self.player = [[VLCMediaPlayer alloc] initWithOptions:nil];
    self.player.delegate = self;
    self.player.drawable = self.videoView;
    VLCMedia *media;
    if (self.path.length > 0) {
        media = [VLCMedia mediaWithPath:self.path];
        self.player.media = media;
    } else if (self.urlString.length > 0) {
        media = [VLCMedia mediaWithURL:[NSURL URLWithString:self.urlString]];
        self.player.media = media;
    }
    
    //设置缓存多少毫秒
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"300" forKey:@"network-caching"];
    [media addOptions:dic];
    
    [self refreshTimeLabel];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.controlView.bounds;
    [self.controlView insertSubview:effectview atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)playOrPauseAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (IBAction)slideAction:(UISlider *)sender {
//    NSLog(@"当前进度：%f", sender.value);
    [self.player setPosition:sender.value];
}

#pragma mark - private
- (void)refreshTimeLabel {
    NSString *currentProgress = self.player.time.stringValue;
    NSString *allTime = self.player.media.length.stringValue;
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", currentProgress, allTime];
}

#pragma mark - VLCMediaPlayerDelegate
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    VLCMediaPlayerState state = self.player.state;
    switch (state) {
        case VLCMediaPlayerStateEnded:
            [self.player stop];
            [self.slider setValue:0 animated:NO];
            self.playButton.selected = NO;
            break;
        case VLCMediaPlayerStatePlaying:
            
            break;
        default:
            break;
    }
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    [self refreshTimeLabel];
    CGFloat currentTime = [self.player.time.value floatValue];
    CGFloat allTime = [self.player.media.length.value floatValue];
    [self.slider setValue:currentTime/allTime animated:YES];
}

#pragma mark - VLCMediaThumbnailerDelegate
- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer {
    NSLog(@"获取帧画面超时");
}

- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail {
    UIImage *thumbImage = [UIImage imageWithCGImage:thumbnail];
    self.imageView.image = thumbImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
