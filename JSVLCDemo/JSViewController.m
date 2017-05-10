//
//  ViewController.m
//  JSVLCDemo
//
//  Created by ShengWang Gao on 2017/5/9.
//  Copyright © 2017年 ShengWang Gao. All rights reserved.
//

#import "JSViewController.h"
#import "JSVLCVideoViewController.h"

@interface JSViewController ()

@end

@implementation JSViewController

static NSString *const segueIdf = @"pushVideoSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)localVideoAction:(id)sender {
    [self performSegueWithIdentifier:segueIdf sender:@(YES)];
}


- (IBAction)remoteVideoAction:(id)sender {
    [self performSegueWithIdentifier:segueIdf sender:@(NO)];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:segueIdf]) {
        JSVLCVideoViewController *videoVC = segue.destinationViewController;
        if ([sender boolValue]) {
            videoVC.path = [[NSBundle mainBundle] pathForResource:@"ceshi1" ofType:@"mp4"];
        } else {
            videoVC.urlString = @"http://112.80.27.18/vmind.qqvideo.tc.qq.com/AH_23Xcz9ZFkkm_NmV7aaSF-UPF4dlBw_SDfYxRrDDzM/p02001xpv31.p202.1.mp4?vkey=FBA7A209DC63F87310A4FD3AED60BAC793EE3DD49DF7F9272D9E537D67E51805DC744183C77378B7909F644F8A3BDE5A56BD326814C09038AD501731A9BD5BFAB6398C5EE8F0F34D5E0E5FAB221C8F9B70B2A39748C479E4&amp;platform=&amp;sdtfrom=&amp;fmt=hd&amp;level=0";
        }
    }
}

@end
