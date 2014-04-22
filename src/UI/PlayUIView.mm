

#import "PlayUIView.h"

#import "AppDelegate.h"

#import "GamePlayEngine.h"

#import "UIImage+TPAdditions.h"

@interface PlayUIView() {
    IBOutlet UIButton * homeButton;
	IBOutlet UIButton * soundOnButton;
	IBOutlet UIButton * soundOffButton;
	IBOutlet UIButton * musicOnButton;
	IBOutlet UIButton * musicOffButton;
	IBOutlet UIButton * helpButton;
	IBOutlet UIButton * nextButton;
	IBOutlet UILabel * scoreLabel;
	
	BOOL clickReady;
	BOOL isHelpOn;
	IBOutlet UIView * container;
	
	IBOutlet UIImageView * helpImage;
	
	id delegate;
}
@end

@implementation PlayUIView

- (void) loadImages {
	
	scoreLabel.font = [UIFont fontWithName:@"HyperionSunsetBRK" size:scoreLabel.font.pointSize];
	
	helpImage.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/helpscreen.png"];
	helpImage.alpha = 0.0f;
	isHelpOn = NO;
	
	[soundOnButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/soundOnButton.png"] forState:UIControlStateNormal];
	[soundOffButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/soundOffButton.png"] forState:UIControlStateNormal];
	[musicOnButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/musicOnButton.png"] forState:UIControlStateNormal];
	[musicOffButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/musicOffButton.png"] forState:UIControlStateNormal];
	[helpButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/helpButton.png"] forState:UIControlStateNormal];
	[nextButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/nextFaceButton.png"] forState:UIControlStateNormal];
	
	[homeButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/homeButton.png"] forState:UIControlStateNormal];
}
- (void) removeImages {
	helpImage.image = nil;

	[soundOnButton setImage:nil forState:UIControlStateNormal];
	[soundOffButton setImage:nil forState:UIControlStateNormal];
	[musicOnButton setImage:nil forState:UIControlStateNormal];
	[musicOffButton setImage:nil forState:UIControlStateNormal];
	[helpButton setImage:nil forState:UIControlStateNormal];
	[nextButton setImage:nil forState:UIControlStateNormal];
	[homeButton setImage:nil forState:UIControlStateNormal];
}

- (void)dealloc {
	[self removeImages];
    
    if(self.delegate) {
        self.delegate = nil;
    }
    [homeButton release];
    homeButton = nil;
	[soundOnButton release];
    soundOnButton = nil;
	[soundOffButton release];
    soundOffButton = nil;
	[musicOnButton release];
    musicOnButton = nil;
	[musicOffButton release];
    musicOffButton = nil;
	[helpButton release];
    helpButton = nil;
	[nextButton release];
    nextButton = nil;
	[container release];
    container = nil;
	[helpImage release];
    helpImage = nil;
	[scoreLabel release];
    scoreLabel = nil;
    
    [super dealloc];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect pauseButtonRect = container.frame;
	CGRect nextButtonRect = nextButton.frame;
    if(CGRectContainsPoint(pauseButtonRect, point)) {
        return YES;
    } else  if(CGRectContainsPoint(nextButtonRect, point)) {
		return YES;
	} else {
		return NO;
	}
}

- (IBAction)homeButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self setClickReady:NO];
		[self playClick];
		if ( [delegate respondsToSelector:@selector(appHomeButtonPressed)] ) {
			[delegate performSelectorOnMainThread:@selector(appHomeButtonPressed) withObject:nil waitUntilDone:NO];
		}
		NSLog(@"Home Button Pressed");
	}
}

- (IBAction)musicOnButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self playClick];
		if ( [delegate respondsToSelector:@selector(appMusicOnButtonPressed)] ) {
			[delegate performSelectorOnMainThread:@selector(appMusicOnButtonPressed) withObject:nil waitUntilDone:NO];
		}
		NSLog(@"Music On Button Pressed");
		musicOffButton.alpha = 1.0;
		musicOnButton.alpha = 0.0;
	}
}

- (IBAction)musicOffButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self playClick];
		if ( [delegate respondsToSelector:@selector(appMusicOffButtonPressed)] ) {
			[delegate performSelectorOnMainThread:@selector(appMusicOffButtonPressed) withObject:nil waitUntilDone:NO];
		}
		NSLog(@"Music Off Button Pressed");
		musicOnButton.alpha = 1.0;
		musicOffButton.alpha = 0.0;
	}
}

- (IBAction)soundOffButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self playClick];
		[self setSoundPlayerOn:YES];
		if ( [delegate respondsToSelector:@selector(appSoundOffButtonPressed)] ) {
			[delegate performSelectorOnMainThread:@selector(appSoundOffButtonPressed) withObject:nil waitUntilDone:NO];
		}
		NSLog(@"Sound Button Pressed");
		soundOffButton.alpha = 0.0;
		soundOnButton.alpha = 1.0;
	}
}

- (IBAction)soundOnButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self playClick];
		[self setSoundPlayerOn:NO];
		if ( [delegate respondsToSelector:@selector(appSoundOnButtonPressed)] ) {
			[delegate performSelectorOnMainThread:@selector(appSoundOnButtonPressed) withObject:nil waitUntilDone:NO];
		}
		NSLog(@"Sound Button Pressed");
		soundOffButton.alpha = 1.0;
		soundOnButton.alpha = 0.0;
	}
}

- (IBAction)helpButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self playClick];
		float helpAlpha = 0.0;
		if(isHelpOn == YES) {
			isHelpOn = NO;
			helpAlpha = 0.0f;
			
		} else {
			isHelpOn = YES;
			helpAlpha = 1.0f;
		}
		[UIView animateWithDuration:0.4
				animations:^{
					[helpImage setAlpha:helpAlpha];
				} completion:^(BOOL finished) {
		}];
		if ( [delegate respondsToSelector:@selector(appHelpButtonPressed)] ) {
			[delegate performSelectorOnMainThread:@selector(appHelpButtonPressed) withObject:nil waitUntilDone:NO];
		}
		NSLog(@"Help Button Pressed");
	}
}

- (IBAction)nextFaceButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self playClick];
		if ( [delegate respondsToSelector:@selector(appNextButtonPressed)] ) {
			[delegate performSelectorOnMainThread:@selector(appNextButtonPressed) withObject:nil waitUntilDone:NO];
		}
		NSLog(@"Next Face Button Pressed");
	}
}

- (void) playClick {
	AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate playClick];
}

- (void) setSoundPlayerOn:(BOOL)value {
	AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate setSoundPlayerOn:value];
}

- (void) setClickReady:(BOOL)isReady {
	clickReady = isReady;
}

- (BOOL) isClickReady {
	return clickReady;
}

- (id)delegate {
    return delegate;
}

- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

- (void) clearDelegate {
	delegate = nil;
}

- (void) setScore:(int)value {
	NSString * number = [NSString stringWithFormat:@"%d", value];
	
	
	[UIView animateWithDuration:0.2 animations:^{
		scoreLabel.alpha = 0.0;
	 } completion:^(BOOL finished) {
		 [scoreLabel setText:number];
		 [UIView animateWithDuration:0.2 animations:^{
			 scoreLabel.alpha = 1.0;
		 } completion:^(BOOL finished) {
		 }];
	 }];
}

@end
