

#import "BaseViewController.h"
#import "AppDelegate.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+TPAdditions.h"

#import "AppGlobals.h"

@interface BaseViewController(){
    UISwipeGestureRecognizer * swipeGesture;
	UIView * fadeCoverView;
	BOOL shouldFade;
	BOOL clickReady;
}

@end

@implementation BaseViewController


- (id)init {
    self = [super init];
    if (self) {
		clickReady = NO;
		shouldFade = YES;
		fadeCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		fadeCoverView.backgroundColor = [UIColor blackColor];
		fadeCoverView.alpha = 1.0;
		[self.view addSubview:fadeCoverView];
		
		
    }
    return self;
}


- (void)dealloc {
    if(swipeGesture != nil) {
        [self.view removeGestureRecognizer:swipeGesture];
        [swipeGesture release];
        swipeGesture = nil;
    }
	
	if(fadeCoverView) {
		[fadeCoverView release];
		fadeCoverView = nil;
	}

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addSwipeBackGesture {
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBackGestureRecognised:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)swipeBackGestureRecognised:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
	[self playClick];
	NSLog(@"BackButtonPressed");
	[self popBack];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if(shouldFade == YES) {
		fadeCoverView.alpha = 1.0;
	} else {
		fadeCoverView.alpha = 0.0;
	}
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	clickReady = YES;
	if(shouldFade == YES) {
		UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
		[UIView animateWithDuration:(kTransitionTime*2.0) delay:0 options:options animations:^{
			fadeCoverView.alpha = 0;
		} completion:^(BOOL finished) {
			//
		}];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	clickReady = NO;
	if(shouldFade == YES) {
		UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
		[UIView animateWithDuration:(kTransitionTime) delay:0 options:options animations:^{
			fadeCoverView.alpha = 1;
		} completion:^(BOOL finished) {
			//
		}];
	}
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if(shouldFade == YES) {
		fadeCoverView.alpha = 1.0;
	} else {
		fadeCoverView.alpha = 0.0;
	}
}

- (void) popBack {
	[self setTransition];
	AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate popBack];
}

- (void) popHome {
	[self setTransition];
	AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate popHome];
}

- (void) setTransition {
	CATransition* transition = [CATransition animation];
    transition.duration = kTransitionTime;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}

- (void) shouldFade:(BOOL)fade {
	shouldFade = fade;
}

- (void) playClick {
	AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate playClick];
}

- (void) setClickReady:(BOOL)isReady {
	clickReady = isReady;
}

- (BOOL) isClickReady {
	return clickReady;
}

@end
