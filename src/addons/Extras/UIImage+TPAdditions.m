//
//  UIImage+TPAdditions.m
//  WatchWithMother
//
//  Created by lukasz karluk on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+TPAdditions.h"

@implementation UIImage (TPAdditions)

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path {
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if([[UIScreen mainScreen] scale] == 2.0 ) {
            NSString *path2x = [[path stringByDeletingLastPathComponent] 
                                stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@", 
                                                                [[path lastPathComponent] stringByDeletingPathExtension], 
                                                                [path pathExtension]]];
            
            NSArray * fileNamSplit = [path2x componentsSeparatedByString:@"."];
            NSString * filePath = [[NSBundle mainBundle] pathForResource:[fileNamSplit objectAtIndex:0] 
                                                                  ofType:[fileNamSplit objectAtIndex:1]];
            
            
            if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
                return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]] CGImage]
                                       scale:2.0 
                                 orientation:UIImageOrientationUp];
            }
        }
    }
    
    NSArray * fileNamSplit = [path componentsSeparatedByString:@"."];
    NSString * filePath = [[NSBundle mainBundle] pathForResource:[fileNamSplit objectAtIndex:0] 
                                                          ofType:[fileNamSplit objectAtIndex:1]];
    
    return [self initWithData:[NSData dataWithContentsOfFile:filePath]];
}

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path {
    return [[[UIImage alloc] initWithContentsOfResolutionIndependentFile:path] autorelease];
}

@end