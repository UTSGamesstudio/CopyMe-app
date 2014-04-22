//
//  AboutViewController.m
//  CopyMe
//
//  Created by Daniel Rosser on 11/10/13.
//
//

#import "AboutViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "UIImage+TPAdditions.h"


@interface AboutViewController () {
	IBOutlet UIButton * homeButton;
	IBOutlet UIScrollView * scrollView;
	IBOutlet UIImageView * buttonBackground;
	UIImageView * aboutImage;
	UIImageView * backgroundLogo;
}
@end



@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    return self;
}

- (void)dealloc {
	[self removeImages];
	[aboutImage release];
	aboutImage = nil;
	[buttonBackground release];
    buttonBackground = nil;
	[homeButton release];
    homeButton = nil;
	[backgroundLogo release];
	backgroundLogo = nil;
	
    if(scrollView) {
		scrollView.delegate = nil;
		[scrollView release];
		scrollView = nil;
	}
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	aboutImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 768, 500)];
	backgroundLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, -74, 768, 512)];

	CGSize contentSize = CGSizeMake(0, 0);
	contentSize.height = 1194;
	contentSize.width = 768 - 32;
	[scrollView setFrame:CGRectMake(0, 0, 768, 1024)];
	[scrollView setContentSize:contentSize];
	scrollView.scrollEnabled = YES;
	scrollView.alwaysBounceHorizontal = NO;
	scrollView.alwaysBounceVertical = YES;
	scrollView.backgroundColor = [UIColor clearColor];
	
	[scrollView addSubview:aboutImage];
	[scrollView addSubview:backgroundLogo];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[TestFlight passCheckpoint:@"About"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadImages];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self removeImages];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadImages {
	buttonBackground.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/bottomBar.png"];
	aboutImage.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/abouttext.png"];
	backgroundLogo.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/ui_logo.png"];
	[homeButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/homeButton.png"] forState:UIControlStateNormal];
}
- (void) removeImages {
	buttonBackground.image = nil;
	aboutImage.image = nil;
	backgroundLogo.image = nil;
	[homeButton setImage:nil forState:UIControlStateNormal];
}

@end
