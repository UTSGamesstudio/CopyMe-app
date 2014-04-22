//
//  NavigationBarView.h
//  CopyMe
//
//  Created by Daniel Rosser on 24/09/13.
//  Copyright (c) 2013 Daniel Rosser. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavigationBarView : UINavigationBar {
	//
}
@property(nonatomic, retain) IBOutlet UINavigationItem * navItem;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (BOOL)isShowing;
- (void)hideSuper;

@end
