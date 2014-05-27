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
    
    
//    //adds a particl
//    CCParticleGalaxy *particleSystem = [CCParticleGalaxy particleWithTotalParticles:20];
//    [particleSystem setTexture:[CCTexture textureWithFile:@"ccbParticleSmoke.png"]];
//    particleSystem.emitterMode = CCParticleSystemPositionTypeRelative;
//    [self addChild:particleSystem];
//                              
	
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

    if (frandom_range(0.0, 1.0) < ASTEROID_OUTLIER_PROB) {
        [self setVarsForProfile:@"outlier"
            minSize:ASTEROID_OUTLIER_SIZE_MIN            maxSize:ASTEROID_OUTLIER_SIZE_MAX
            minSpeed:ASTEROID_OUTLIER_SPEED_MIN          maxSpeed:ASTEROID_OUTLIER_SPEED_MAX
            minAngle:ASTEROID_OUTLIER_ANGLE_MIN          maxAngle:ASTEROID_OUTLIER_ANGLE_MAX
            minAngVel:ASTEROID_OUTLIER_ANGLEVELOCITY_MIN maxAngVel:ASTEROID_OUTLIER_ANGLEVELOCITY_MAX];
    }
    else {
        [self setVarsForProfile:@"normal"
            minSize:ASTEROID_SIZE_MIN            maxSize:ASTEROID_SIZE_MAX
            minSpeed:ASTEROID_SPEED_MIN          maxSpeed:ASTEROID_SPEED_MAX
            minAngle:ASTEROID_ANGLE_MIN          maxAngle:ASTEROID_ANGLE_MAX
            minAngVel:ASTEROID_ANGLEVELOCITY_MIN maxAngVel:ASTEROID_ANGLEVELOCITY_MAX];
    }
}

- (void) setVarsForProfile:(NSString *)name
        minSize:(float)minSize     maxSize:(float)maxSize
        minSpeed:(float)minSpeed   maxSpeed:(float)maxSpeed
        minAngle:(float)minAngle   maxAngle:(float)maxAngle
        minAngVel:(float)minAngVel maxAngVel:(float)maxAngVel
{
    float scale = frandom_range(minSize, maxSize);
    float speed = frandom_range(minSpeed, maxSpeed);
    float toEarth = -ccpToAngle(singleton.asteroidPos);
    float randomFactor = frandom_range(minAngle, maxAngle) * random() > 0 ? 1 : -1;
    float angle = toEarth + randomFactor;
    float angularVelocity = frandom_range(minAngVel, maxAngVel) * random() > 0 ? 1 : -1;
    
    //Holy shit this code is so fucking beautiful -Wilson
    
    self.scale = scale;
    [self.physicsBody setVelocity:ccpMult(ccp(cosf(angle), sinf(angle)), speed)];
    [self.physicsBody setAngularVelocity:angularVelocity];
}

@end
