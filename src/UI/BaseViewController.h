

@interface BaseViewController : UIViewController


- (void) addSwipeBackGesture;
- (void) swipeBackGestureRecognised:(id)sender;
- (void) setTransition;
- (void) shouldFade:(BOOL)fade;

- (void) popBack;
- (void) popHome;

- (void) playClick;

- (void) setClickReady:(BOOL)isReady;
- (BOOL) isClickReady;


@end
