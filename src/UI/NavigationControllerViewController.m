//
//  NavigationControllerViewController.m
//  CopyMe
//
//  Created by Daniel Rosser on 24/09/13.
//  Copyright (c) 2013 Daniel Rosser. All rights reserved.
//

#import "NavigationControllerViewController.h"

@interface NavigationControllerViewController () {
}

@end

@implementation NavigationControllerViewController

@synthesize navBar;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        self.delegate = self;
		super.navigationController.interactivePopGestureRecognizer.enabled = NO;
		self.navigationController.interactivePopGestureRecognizer.enabled = NO;
		//self.navigationController.interactivePopGestureRecognizer.delegate = nil
		[self.navBar show:NO];
		
    }
	
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController : (UINavigationController *)navigationController
      willShowViewController : (UIViewController *)viewController
                    animated : (BOOL)animated {
	
    NSString * viewControllerName;
    viewControllerName = [[viewController class] description];
	
	if([self isNavBarHiddenForViewController:viewControllerName] == YES){
		[navBar show:YES];
	} else {
		[navBar hide:YES];
	}
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated  {
	
	NSString *viewControllerName;
    viewControllerName = [[viewController class] description];
	
	if([self isNavBarHiddenForViewController:viewControllerName] == YES){
		[navBar show:YES];
	} else {
		[navBar hide:YES];
	}
	
}

// Deprecated in iOS6, still needed for iOS5 support.
// ---
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

// iOS6 support
// ---
- (BOOL)shouldAutorotate
{
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

-(void)hideSuper {
	[navBar hideSuper];
}

- (NSString*)doesNavBarHaveATitle:(NSString *)viewControllerName {
    NSString* bTitle = Nil;
	// Add to the list if hidden navbar
    if([viewControllerName isEqualToString:@"AboutTopViewController"]) {
		bTitle = @"About";
	}
    return bTitle;
}

- (BOOL)isNavBarBackButtonHome:(NSString *)viewControllerName {
    BOOL bHome = NO;
	// Add to the list if hidden navbar
    bHome = bHome || [viewControllerName isEqualToString:@"AboutTopViewController"];
    bHome = bHome || [viewControllerName isEqualToString:@"SettingsViewController"];
	bHome = bHome || [viewControllerName isEqualToString:@"GalleryViewController"];
	bHome = bHome || [viewControllerName isEqualToString:@"MyVideosViewController"];
	bHome = bHome || [viewControllerName isEqualToString:@"MakeFilmViewController"];
	//    bHidden = bHidden || [viewControllerName isEqualToString:@"OtherViewController"];
    return bHome;
}

//-------------------------------------------------------------------- checks for types of view controllers.
- (BOOL)isNavBarHiddenForViewController:(NSString *)viewControllerName {
    BOOL bHidden = NO;
	// Add to the list if hidden navbar
    //bHidden = bHidden || [viewControllerName isEqualToString:@"MakeFilmViewController"];
//    bHidden = bHidden || [viewControllerName isEqualToString:@"SurveyViewController"];
//	bHidden = bHidden || [viewControllerName isEqualToString:@"AboutViewController"];
   // bHidden = bHidden || [viewControllerName isEqualToString:@"HomeViewController"];
	//    bHidden = bHidden || [viewControllerName isEqualToString:@"OtherViewController"];
    return bHidden;
}




@end
