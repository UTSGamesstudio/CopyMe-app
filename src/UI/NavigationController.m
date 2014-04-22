//
//  NavigationController.m
//  CopyMe
//
//  Created by Daniel Rosser on 29/10/2013.
//
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        self.delegate = self;
    }
    return self;
}

- (void)navigationController : (UINavigationController *)navigationController
      willShowViewController : (UIViewController *)viewController
                    animated : (BOOL)animated {
	
    NSString * viewControllerName;
    viewControllerName = [[viewController class] description];
    //
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated  {
    
    NSString *viewControllerName;
    viewControllerName = [[viewController class] description];
    //
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

