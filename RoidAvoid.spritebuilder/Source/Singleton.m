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
    NSArray *vars = [NSArray arrayWithObjects:@"ControlScheme, FXVolume, BGVolume", nil];
    NSArray *values = [NSArray arrayWithObjects:kTouch, [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:0.5f], nil];
    for (int index = 1; index < [vars count]; index++) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:vars[index]]intValue] == 0) {
            [[NSUserDefaults standardUserDefaults]setObject:values[index] forKey:vars[index]];
            NSLog(@"Set Default Var: %@",vars[index]);
        }
    }
    
}

- (void) chooseEvent:(AsteroidEvent)event
{
    if (event == kNormal) {
        self.asteroidEvent = kNormal;
    } else {
        float chance = frandom_range(0, 10000);
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
