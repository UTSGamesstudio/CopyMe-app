//
//  UIImage+TPAdditions.h
//  WatchWithMother
//
//  Created by lukasz karluk on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TPAdditions)
- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path;
+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path;
@end
