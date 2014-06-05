//
//  Singleton.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Singleton.h"



@implementation Singleton

+ (id)sharedManager {
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id) init {
    if (self = [super init]) {
        _firstGame = TRUE;
        _motionManager = [[CMMotionManager alloc] init];
        
        
        [self setDefaultVars];
    }
    return self;
}

- (void) setDefaultVars
{
    NSMutableArray *vars = [NSMutableArray arrayWithObjects:@"ControlScheme", @"FXVolume", @"BGVolume", nil];
    NSMutableArray *values = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:kNormal], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:0.5f], nil];
    for (int index = 1; index < [vars count]; index++) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:vars[index]] == nil) {
            [[NSUserDefaults standardUserDefaults]setObject:[values objectAtIndex:index] forKey:[vars objectAtIndex:index]];
            
        }
    }
    
}

- (void) chooseEvent:(AsteroidEvent)event
{
    if (event == kNormal) {
        self.asteroidEvent = kNormal;
    } else {
#pragma mark CHANGE THIS CHANCE TO NEW VERSION ONCE IT COMES OUT
        float chance = frandom_range(0, 1);
        float chanceLimit= 9990;
        if (chance>chanceLimit) {
            if (self.asteroidEvent == kNormal) {
                self.asteroidEvent = kShower;
                
                NSLog(@"switched!");
            }
        }
    }
}

- (void) switchEvent
{
    
    
}
@end
