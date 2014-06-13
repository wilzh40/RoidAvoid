//
//  PauseScene.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 6/12/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "PauseScene.h"
#import "Singleton.h"
@implementation PauseScene

- (void) pressedBack
{
    [[CCDirector sharedDirector]popScene];
    Singleton *singleton = [Singleton sharedManager];
 
}
@end
