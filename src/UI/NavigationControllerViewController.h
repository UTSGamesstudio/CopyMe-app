//
//  NavigationControllerViewController.h
//  CopyMe
//
//  Created by Daniel Rosser on 24/09/13.
//  Copyright (c) 2013 Daniel Rosser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarView.h"

@interface NavigationControllerViewController : UINavigationController <UINavigationControllerDelegate> {
	//
}

@property(nonatomic, retain) IBOutlet NavigationBarView * navBar;


-(void)hideSuper;


@end
