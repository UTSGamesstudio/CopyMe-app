//
//  AppDelegate.h
//  CopyMe
//
//  Created by Daniel Rosser on 1/10/13.
//
//

#import <Foundation/Foundation.h>

#import "AVSoundPlayer.h"

@class NavigationController;
@class GameEngineViewController;

//@interface AppDelegate : FacebookManager <FacebookManagerDelegate> {
//    //
//}
@interface AppDelegate : NSObject<UIApplicationDelegate> {
}

@property (nonatomic, retain) NavigationController * navigationController;
@property (nonatomic, retain) GameEngineViewController * gameController;
@property (nonatomic, retain) UIImageView * splashImageView;
@property (nonatomic, retain) UIImageView * backgroundImage;




- (void)showSplashImage;
- (void)hideSplashImage;

- (void) popBack;
- (void) popHome;

- (void) loadBackground;
- (void) removeBackground;

- (void) playClick;
- (void) setSoundPlayerOn:(BOOL)value;

@end
