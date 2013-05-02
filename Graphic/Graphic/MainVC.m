//
//  MainVC.m
//  Graphic
//
//  Created by ThanhTung on 5/2/13.
//  Copyright (c) 2013 THANHTUNG. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"ĐỒ THỊ HÀM SỐ";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    NSString *pathname = [[NSBundle mainBundle]  pathForResource:@"graphic" ofType:@"html" inDirectory:@"/"];
    NSString *htmlString = [NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    _webView.delegate = self;
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)playSound{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ruocdenthangtam" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [_audioPlayer play];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"techmaster"]) {
        NSLog(@"%@",url.scheme);
        [self playSound];
    }
    return YES;
}
@end
