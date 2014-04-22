//
//  BaseWebViewController.h
//
//  Created by Daniel Rosser on 18/09/13.
//
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController {
	//
}

- (void)loadWebURL:(NSString *)address;
- (void)loadCustomWebURL:(NSString *)address;
- (void)showFailedCover;
- (void)hideFailedCover;


@end
