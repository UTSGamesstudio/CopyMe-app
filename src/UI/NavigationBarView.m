//
//  NavigationBarView.m
//  CopyMe
//
//  Created by Daniel Rosser on 24/09/13.
//  Copyright (c) 2013 Daniel Rosser. All rights reserved.
//

#import "NavigationBarView.h"
#import <QuartzCore/QuartzCore.h>

@interface NavigationBarView() {
    bool bShowing;
    CGRect frameShow;
    CGRect frameHide;
}
@end

@implementation NavigationBarView

@synthesize navItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
	if(navItem){
		[navItem release];
	}
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
	
	
	//    int w = self.frame.size.width; //[[UIScreen mainScreen] bounds].size.width;
	//    int h = self.frame.size.height; //[self sizeThatFits:self.bounds.size].height;
	int w = [[UIScreen mainScreen] bounds].size.width;
    int h = [self sizeThatFits:self.bounds.size].height;
    
    bShowing = true;
    frameShow = CGRectMake(0, 0, w, h);
    frameHide = CGRectMake(0, 0 - h, w, h);
	
    [self hide:NO];
	
	[self setHidden:YES];
	[super setHidden:YES]; // FIXES THE NAVBAR ON HOME!!!!!!!!!!!!!!!!!
	
}

-(void)hideSuper {
	[super setHidden:YES]; // FIXES THE NAVBAR ON HOME!!!!!!!!!!!!!!!!!
}

- (void)show:(BOOL)animated {
	if(self.hidden)
		[self setHidden:NO];
	
    if(bShowing) {
        return;
    }
    
    bShowing = true;
    
    if(!animated) {
        [self show];
        return;
    }
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.3 delay:0.0 options:options animations:^{
        [self show];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)show {
    self.alpha = 1;
    self.frame = frameShow;
}

- (void)hide:(BOOL)animated {
	
    if(!bShowing) {
        return;
    }
    
    bShowing = false;
    
    if(!animated) {
        [self hide];
        return;
    }
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.3 delay:0.0 options:options animations:^{
        [self hide];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hide {
    self.alpha = 0;
    self.frame = frameHide;
}

- (BOOL)isShowing {
    return bShowing;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
