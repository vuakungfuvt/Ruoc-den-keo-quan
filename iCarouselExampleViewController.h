//
//  iCarouselExampleViewController.h
//  iCarouselExample
//dioP
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <AVFoundation/AVFoundation.h>


@interface iCarouselExampleViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>{
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;

@end
