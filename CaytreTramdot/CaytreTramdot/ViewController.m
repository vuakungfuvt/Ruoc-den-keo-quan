//
//  ViewController.m
//  CaytreTramdot
//
//  Created by ThanhTung on 4/25/13.
//  Copyright (c) 2013 THANHTUNG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray *arrImage;
    NSArray *arrTime;
    UIImageView *imvPage;
    int currentPage;
    UILabel *lblPage;
    int timeStart;
    int timeStop;
    NSDictionary *dicTime;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrImage = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 12; i++) {
        NSString *name = [NSString stringWithFormat:@"%d.png",i];
        [arrImage addObject:[UIImage imageNamed:name]];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"plist"];
    arrTime = [[NSArray alloc] initWithContentsOfFile:path];
    currentPage = 0;
    imvPage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imvPage.image = [arrImage objectAtIndex:currentPage];
    lblPage = [[UILabel alloc] initWithFrame:CGRectMake(200, 400, 100, 30)];
    lblPage.textColor = [UIColor redColor];
    lblPage.backgroundColor = [UIColor clearColor];
    lblPage.text = [NSString stringWithFormat:@"%d",currentPage];
    [imvPage addSubview:lblPage];
    [self.view addSubview:imvPage];
	self.title = @"Cây tre trăm đốt";
    dicTime = [[NSDictionary alloc] init];
    dicTime = [arrTime objectAtIndex:currentPage];
    imvPage.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    left.direction = UIAccessibilityScrollDirectionLeft;
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    right.direction = UIAccessibilityScrollDirectionRight;
    [imvPage addGestureRecognizer:left];
    [imvPage addGestureRecognizer:right];
    [self playSound];
    
    NSNumber *start = [NSNumber new];
    NSNumber *stop = [NSNumber new];
    start = [dicTime objectForKey:@"start"];
    stop = [dicTime objectForKey:@"stop"];
    timeStart = [start intValue];
    timeStop = [stop intValue];
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:timeStop - timeStart target:self selector:@selector(stopAudio:) userInfo:nil repeats:NO];
}
- (void) swipeLeft : (UISwipeGestureRecognizer*) sender{
    if (currentPage < arrImage.count - 1) {
        currentPage++;
        [UIView transitionWithView:imvPage duration:1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            imvPage.image = [arrImage objectAtIndex:currentPage];
            lblPage.text = [NSString stringWithFormat:@"%d",currentPage];
        }completion:^(BOOL finished){
            
        }];
        dicTime = [arrTime objectAtIndex:currentPage];
        NSNumber *start = [NSNumber new];
        NSNumber *stop = [NSNumber new];
        start = [dicTime objectForKey:@"start"];
        stop = [dicTime objectForKey:@"stop"];
        timeStart = [start intValue];
        timeStop = [stop intValue];
        NSLog(@"%d %d",timeStart,timeStop);
        [self playSound];
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:timeStop - timeStart target:self selector:@selector(stopAudio:) userInfo:nil repeats:NO];
    }
}
- (void) swipeRight : (UISwipeGestureRecognizer*) sender{
    //NSLog(@"tung");
    if (currentPage > 1) {
        currentPage--;
        [UIView transitionWithView:imvPage duration:1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            imvPage.image = [arrImage objectAtIndex:currentPage];
            lblPage.text = [NSString stringWithFormat:@"%d",currentPage];
        }completion:^(BOOL finished){
            
        }];
        dicTime = [arrTime objectAtIndex:currentPage];
        NSNumber *start = [NSNumber new];
        NSNumber *stop = [NSNumber new];
        start = [dicTime objectForKey:@"start"];
        stop = [dicTime objectForKey:@"stop"];
        timeStart = [start intValue];
        timeStop = [stop intValue];
        NSLog(@"%d %d",timeStart,timeStop);
        [self playSound];
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:timeStop - timeStart target:self selector:@selector(stopAudio:) userInfo:nil repeats:NO];
    }
}
- (void) stopAudio : (NSTimer*) sender{
    [_audioPlayer stop];
}
- (void) playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"mp3"];
    NSURL *url= [[NSURL alloc] initFileURLWithPath:path];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    _audioPlayer.currentTime = timeStart;
    [_audioPlayer play];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
