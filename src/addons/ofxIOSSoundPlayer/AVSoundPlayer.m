//
//  AVSoundPlayer.m
//
//  Created by lukasz karluk on 14/06/12.
//

#import "AVSoundPlayer.h"

@interface AVSoundPlayer() {
    BOOL bMultiPlay;
}
@end

@implementation AVSoundPlayer

@synthesize delegate;
@synthesize player;
@synthesize timer;

- (id)init {
    self = [super init];
    if(self) {
        bMultiPlay = NO;
    }
    return self;
}

- (void)dealloc {
    [self unloadSound];
    [super dealloc];
}

//----------------------------------------------------------- load / unload.
- (BOOL)loadWithFile:(NSString*)file {
    NSArray * fileSplit = [file componentsSeparatedByString:@"."];
    NSURL * fileURL = [[NSBundle mainBundle] URLForResource:[fileSplit objectAtIndex:0] 
                                              withExtension:[fileSplit objectAtIndex:1]];
	return [self loadWithURL:fileURL];
}

- (BOOL)loadWithPath:(NSString*)path {
    NSURL * fileURL = [NSURL fileURLWithPath:path];
	return [self loadWithURL:fileURL];
}

- (BOOL)loadWithURL:(NSURL*)url {
    [self unloadSound];
    
    NSError * error = nil;
    self.player = [[[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                          error:&error] autorelease];
    [self.player setEnableRate:YES];
    [self.player prepareToPlay];
    if(error) {
        if([self.delegate respondsToSelector:@selector(soundPlayerError:)]) {
            [self.delegate soundPlayerError:error];
        }
        return NO;
    }
    
    self.player.delegate = self;
    return YES;
}

- (void)unloadSound {
    [self stop];
    self.player.delegate = nil;
    self.player = nil;
}

//----------------------------------------------------------- play / pause / stop.
- (void)play {
    if([self isPlaying]) {
        [self position:0];
        return;
    }
    BOOL bOk = [self.player play];
    if(bOk) {
        [self startTimer];
    }
}

- (void)pause {
    [self.player pause];
    [self stopTimer];
}

- (void)stop {
    [self.player stop];
    [self stopTimer];
}

//----------------------------------------------------------- states.
- (BOOL)isLoaded {
    return (self.player != nil);
}

- (BOOL)isPlaying {
    if(self.player == nil) {
        return NO;
    }
    return self.player.isPlaying;
}

//----------------------------------------------------------- properties.
- (void)volume:(float)value {
    self.player.volume = value;
}

- (float)volume {
    if(self.player == nil) {
        return 0;
    }
    return self.player.volume;
}

- (void)pan:(float)value {
    self.player.pan = value;
}

- (float)pan {
    if(self.player == nil) {
        return 0;
    }
    return self.player.pan;
}

- (void)speed:(float)value {
    self.player.rate = value;
}

- (float)speed {
    if(self.player == nil) {
        return 0;
    }
    return self.player.rate;
}

- (void)loop:(BOOL)bLoop {
    if(bLoop) {
        self.player.numberOfLoops = -1;
    } else {
        self.player.numberOfLoops = 0;
    }
}

- (BOOL)loop {
    return self.player.numberOfLoops < 0;
}

- (void)multiPlay:(BOOL)value {
    bMultiPlay = value;
}

- (BOOL)multiPlay {
    return bMultiPlay;
}

- (void)position:(float)value {
    self.player.currentTime = value * self.player.duration;
}

- (float)position {
    if(self.player == nil) {
        return 0;
    }
    return self.player.currentTime / (float)self.player.duration;
}

- (void)positionMs:(int)value {
    self.player.currentTime = value / 1000.0;
}

- (int)positionMs {
    if(self.player == nil) {
        return 0;
    }
    return self.player.currentTime * 1000;
}

//----------------------------------------------------------- timer.
- (void)updateTimer {
    if([self.delegate respondsToSelector:@selector(soundPlayerDidChange)]) {
        [self.delegate soundPlayerDidChange];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer {
    [self stopTimer];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                  target:self 
                                                selector:@selector(updateTimer) 
                                                userInfo:nil 
                                                 repeats:YES];
}

//----------------------------------------------------------- audio player events.
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player 
                                 error:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(soundPlayerError:)]) {
        [self.delegate soundPlayerError:error];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player 
                       successfully:(BOOL)flag {
    [self stopTimer];
    
    if([self.delegate respondsToSelector:@selector(soundPlayerDidFinish)]) {
        [self.delegate soundPlayerDidFinish];
    }
}

@end