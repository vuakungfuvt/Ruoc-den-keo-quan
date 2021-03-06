//
//  MainVC.h
//  Graphic
//
//  Created by ThanhTung on 5/2/13.
//  Copyright (c) 2013 THANHTUNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MainVC : UIViewController<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
