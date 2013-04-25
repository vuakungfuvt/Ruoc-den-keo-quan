//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iCarouselExampleViewController.h"

#define SCROLL_SPEED 1 //items per second, can be negative or fractional


@interface iCarouselExampleViewController (){
    BOOL ok;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, assign) NSTimer *scrollTimer;
@property (nonatomic, assign) NSTimeInterval lastTime;

@end


@implementation iCarouselExampleViewController

@synthesize carousel;
@synthesize items;
@synthesize scrollTimer;
@synthesize lastTime;

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    for (int i = 0; i <= 10; i++)
    {
        NSString *name = [NSString stringWithFormat:@"%d.jpg",i];
        [items addObject:[UIImage imageNamed:name]];
    }
}

- (void)dealloc
{
    //stop timer
    [scrollTimer invalidate];
    
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    carousel.delegate = nil;
    carousel.dataSource = nil;
    //[self playAudio];
    [carousel release];
    [items release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    ok = NO;
    //configure carousel
    //self.view.backgroundColor = [UIColor whiteColor];
    carousel.type = iCarouselTypeCylinder;
    [self playAudio];
    carousel.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeft:)];
    left.direction = UIViewAnimationOptionTransitionFlipFromLeft;
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRight:)];
    right.direction = UIViewAnimationOptionTransitionFlipFromRight;
    [carousel addGestureRecognizer:left];
    [carousel addGestureRecognizer:right];
    //start scrolling
    [self startScrolling];
}
- (void) handleLeft : (UISwipeGestureRecognizer*)sender{
    NSLog(@"1");
    ok = NO;
}
- (void) handleRight : (UISwipeGestureRecognizer*)sender{
    ok = YES;
    NSLog(@"2");
}
- (void) playAudio{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ruocdenthangtam" ofType:@"mp3"];
    NSURL *url= [[NSURL alloc] initFileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
	audioPlayer.numberOfLoops = -1;
	[audioPlayer play];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
}
- (void) play:(iCarousel *)carousel{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/ruocdenthangtam.mp3", [[NSBundle mainBundle] resourcePath]]];
	self.view.backgroundColor = [UIColor whiteColor];
	NSError *error;
	NSData *songFile = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error ];
    audioPlayer = [[AVAudioPlayer alloc] initWithData:songFile error:&error];
	audioPlayer.numberOfLoops = -1;
	
	if (audioPlayer == nil)
		NSLog(@"%@",[NSString stringWithFormat:@"%@",[error description]]);
	else
		[audioPlayer play];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIImageView *imv = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)] autorelease];
        ((UIImageView *)view).image = [UIImage imageNamed:@"trungthu.jpg"];
        //view.contentMode = UIViewContentModeCenter;
        imv = [[[UIImageView alloc] initWithFrame:view.bounds]autorelease];
        label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:imv];
    }
    else
    {
        //get a reference to the label in the recycled view
        //label = (UILabel *)[view viewWithTag:1];
    }
    //label.text = [[items objectAtIndex:index] stringValue];
    imv.image = [items objectAtIndex:index];
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionSpacing:
            return value * 1.1;
        default:
            return value;
    }
}

#pragma mark -
#pragma mark Autoscroll
 
- (void)startScrolling
{
    if (ok) {
        [scrollTimer invalidate];
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                       target:self
                                                     selector:@selector(scrollStep)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    else{
        [self stopScrolling];
        [scrollTimer invalidate];
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                       target:self
                                                     selector:@selector(scrollStepnguoc)
                                                     userInfo:nil
                                                      repeats:YES];
    }
}

- (void)stopScrolling
{
    [scrollTimer invalidate];
    scrollTimer = nil;
}

- (void)scrollStep
{
    //calculate delta time
    NSLog(@"%@",ok);
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = lastTime - now;
    lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!carousel.dragging && !carousel.decelerating)
    {
        //scroll carousel
        carousel.scrollOffset += delta * (float)(SCROLL_SPEED);
    }
}
- (void)scrollStepnguoc
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = lastTime - now;
    lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!carousel.dragging && !carousel.decelerating)
    {
        //scroll carousel
        carousel.scrollOffset -= delta * (float)(SCROLL_SPEED);
    }
}

@end
