//
//  Asteroid.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Asteroid.h"
#import "Singleton.h"

@implementation Asteroid

-(void)onEnter
{
    
    
    singleton = [Singleton sharedManager];
    winSize = [[CCDirector sharedDirector]viewSize];
	
	[super onEnter];
}

@end