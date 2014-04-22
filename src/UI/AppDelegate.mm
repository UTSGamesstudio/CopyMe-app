//
//  AppDelegate.m
//  CopyMe
//
//  Created by Daniel Rosser on 1/10/13.
//
//

#import "AppDelegate.h"

#import "ofMain.h"
#import "ofxiPhone.h"
#import "ofxiPhoneExtras.h"
#import "Globals.h"
#import "AppGlobals.h"

#import "AppDelegate.h"
//#import "AppModel.h"
#import "NavigationController.h"
#import "GameEngineViewController.h"
#import "HomeViewController.h"
#import "UIImage+TPAdditions.h"

//#import "TestFlight.h"


@interface AppDelegate() {
	BOOL isSoundPlayerOn;
}
@property (nonatomic, retain) AVSoundPlayer * soundPlayer;
@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize splashImageView;
@synthesize backgroundImage;
@synthesize soundPlayer;



- (void)dealloc {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSplashImage) object:nil];
    self.window = nil;
	if(self.splashImageView) {
		self.splashImageView.image = nil;
	}
    self.splashImageView = nil;
	if(backgroundImage){
		backgroundImage = nil;
	}
	if(soundPlayer != nil) {
        [soundPlayer setDelegate:nil];
        [soundPlayer unloadSound];
		[soundPlayer release];
		soundPlayer = nil;
	}
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    self.window = [[[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
	[self.window makeKeyAndVisible];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	//[TestFlight takeOff:@"040d50f4-aab6-4948-8e2f-04726c8d9f2d"];
	
	// set data path root for ofToDataPath()
	// path on iPhone will be ~/Applications/{application GUID}/openFrameworks.app/data
	// get the resource path for the bundle (ie '~/Applications/{application GUID}/openFrameworks.app')
	NSString *bundle_path_ns = [[NSBundle mainBundle] resourcePath];
	string path = [bundle_path_ns UTF8String];
	path.append( "/" );
	ofLog(OF_LOG_VERBOSE, "setting data path root to " + path);
	ofSetDataPathRoot( path );
	//-----
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		// Load resources for iOS 6.1 or earlier
		NSLog(@"<iOS7");
	} else {
		// Load resources for iOS 7 or later
		NSLog(@">=iOS7");
	}
    
   // [MagicalRecordHelpers setupAutoMigratingCoreDataStack];
    
   // [[AppModel sharedInstance] initAppData];
	
	self.backgroundImage = nil;
	self.backgroundImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)] autorelease];
	[self loadBackground];
	[self.window addSubview:self.backgroundImage];
	
	if(self.soundPlayer == nil) {
		self.soundPlayer = [[[AVSoundPlayer alloc] init] autorelease];
		self.soundPlayer.delegate = self;
		NSString * soundString = @"sounds/click.wav";
		bool bOk = [self.soundPlayer loadWithFile:soundString];
		NSLog(@"Sound: loaded: %i", (bool)bOk);
		[self.soundPlayer volume:0.2];
	}
	
	 
    UINib * nib = [UINib nibWithNibName:@"NavigationControllerViewController" bundle:nil];
    self.navigationController = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    [self.window setRootViewController:self.navigationController];
	
	[self.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
	
    //[self.navigationController pushViewController:[[[GameEngineViewController alloc] init] autorelease] animated:YES];
	[self.navigationController pushViewController:[[[HomeViewController alloc] init] autorelease] animated:NO];
	
	NSString * splashString = @"Default-700-Portrait.png";
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		splashString = @"Default-Portrait.png";
	}
	
    self.splashImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:splashString]] autorelease];
    [self.navigationController.view addSubview:self.splashImageView];
	
    
    [self performSelector:@selector(hideSplashImage) withObject:nil afterDelay:2.0];
	self.window.rootViewController = navigationController;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
	
	
	[self setSoundPlayerOn:YES];
	
	//[self listAllFonts];

	
    return YES;
}

//---------------------------------------------------------------------
-(void)applicationWillResignActive:(UIApplication *)application {
    [ofxiPhoneGetGLView() stopAnimation];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    //[super applicationDidBecomeActive:application];
    
    [ofxiPhoneGetGLView() startAnimation];
    
//	if([[AppModel sharedInstance] getUserAlreadySet] == true) {
//		[[AppModel sharedInstance] tryAndSubmitUserRegistrationIfNeeded];
//	}
}

-(void)applicationWillTerminate:(UIApplication *)application {
    //[MagicalRecordHelpers cleanUp];
    
    [ofxiPhoneGetGLView() stopAnimation];
	//[super ]
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
}

//---------------------------------------------------------------------
//- (void)facebookLoggedIn:(id)sender {
//    //
//}
//
//- (void)facebookLoggedOut:(id)sender {
//    //
//}
//
//- (void)facebookShareSuccess:(id)sender {
//    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil
//                                                         message:@"Successfully posted to Facebook"
//                                                        delegate:nil
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil] autorelease];
//    [alertView show];
//}
//
//- (void)facebookError:(id)sender error:(NSString *)error {
//    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Error"
//                                                         message:error
//                                                        delegate:nil
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil] autorelease];
//    [alertView show];
//}
//
//---------------------------------------------------------------------
- (void)listAllFonts {
    NSArray * fontFamilies = [UIFont familyNames];
    for(int i=0; i<[fontFamilies count]; i++) {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

//---------------------------------------------------------------------
- (void)showSplashImage {
	
//	if(self.splashImageView == nil) {
//		NSString * splashString = @"Default.png";
//		self.splashImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:splashString]] autorelease];
//		[self.navigationController.view addSubview:self.splashImageView];
//	}
//	
//    [UIView animateWithDuration:0.4
//                     animations:^{
                         [self.splashImageView setAlpha:1.0];
//                     } completion:^(BOOL finished) {
//                         
//                     }];
}
//---------------------------------------------------------------------
- (void)hideSplashImage {
    [UIView animateWithDuration:0.8
                     animations:^{
                         [self.splashImageView setAlpha:0.0];
                     } completion:^(BOOL finished) {
//                         [self.splashImageView removeFromSuperview];
//                         self.splashImageView = nil;
                     }];
}
//---------------------------------------------------------------------
- (void)popBack {
	if(self.navigationController != nil) {
		[self.navigationController popViewControllerAnimated:NO];
	}
}

//---------------------------------------------------------------------
- (void)popHome {
	NSArray * currentViewControllers = self.navigationController.viewControllers;
	NSMutableArray * newViewControllers = [NSMutableArray array];
	[newViewControllers addObject:[currentViewControllers objectAtIndex:0]];
	[newViewControllers addObject:[currentViewControllers objectAtIndex:1]];
	[self.navigationController setViewControllers:newViewControllers animated:NO];

}

//---------------------------------------------------------------------
- (void) loadBackground {
	self.backgroundImage.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/background.jpg"];
}

//---------------------------------------------------------------------
- (void) removeBackground {
	//[self.backgroundImage removeFromSuperview];
	self.backgroundImage.image = nil;
}
//---------------------------------------------------------------------
- (void) playClick {
	if(isSoundPlayerOn) {
		[self.soundPlayer play];
	} else {
		return;
	}
	
}


- (void) setSoundPlayerOn:(BOOL)value {
	isSoundPlayerOn = value;
}

@end
