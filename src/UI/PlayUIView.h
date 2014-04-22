

#import <UIKit/UIKit.h>

@interface PlayUIView : UIView

- (void) setClickReady:(BOOL)isReady;
- (BOOL) isClickReady;

- (id) delegate;
- (void) setDelegate:(id)newDelegate;
- (void) clearDelegate;

- (void) removeImages;
- (void) loadImages;

- (void) setScore:(int)value;


@end
