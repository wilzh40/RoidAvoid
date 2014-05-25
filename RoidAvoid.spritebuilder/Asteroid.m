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

- (void) onEnter
{
    singleton = [Singleton sharedManager];
    winSize = [[CCDirector sharedDirector]viewSize];
	
    [self setVars];
	[super onEnter];
}

- (void) setVars
{

    
    // This is used to pick which collision delegate method to call, see GameScene.m for more info.
	self.physicsBody.collisionType = @"asteroid";
	// This sets up simple collision rules.
	// First you list the categories (strings) that the object belongs to.
	self.physicsBody.collisionCategories = @[@"asteroid"];
	// Then you list which categories its allowed to collide with.
	self.physicsBody.collisionMask = @[@"hero", @"planet",@"boundary",@"asteroid"];


    
        
    


    float scale = frandom_range(ASTEROID_SIZE_MIN, ASTEROID_SIZE_MAX);
    self.scale = scale;

    float speed = frandom_range(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX);
    float toEarth = -ccpToAngle(singleton.asteroidPos);
    float randomFactor = frandom_range(ASTEROID_ANGLE_MIN, ASTEROID_ANGLE_MAX) * random() > 0 ? 1 : -1;
    float angle = toEarth + randomFactor;
    float angularVelocity = frandom_range(ASTEROID_ANGLEVELOCITY_MIN, ASTEROID_ANGLEVELOCITY_MAX);

    [self.physicsBody setVelocity:ccpMult(ccp(cosf(angle), sinf(angle)), speed)];
    [self.physicsBody setAngularVelocity:angularVelocity];

    NSLog(@"Asteroid created with angle %f", angle);

}

@end
