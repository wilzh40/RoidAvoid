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
    [self addParticles];
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
	self.physicsBody.collisionMask = @[@"hero", @"planet",@"boundary"];

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
    float toEarth = -ccpToAngle(self.position);
    float randomFactor = frandom_range(minAngle, maxAngle) * random() > 0 ? 1 : -1;
    float angle = toEarth + randomFactor;
    float angularVelocity = frandom_range(minAngVel, maxAngVel) * random() > 0 ? 1 : -1;
    
    //Holy shit this code is so fucking beautiful -Wilson
    
    [self doScale:scale];
    [self.physicsBody setVelocity:ccpMult(ccp(cosf(angle), sinf(angle)), speed)];
    [self.physicsBody setAngularVelocity:angularVelocity];
}

- (void) doScale:(float)scale
{
    self.scale = scale;
    self.physicsBody.mass = scale;
    _asteroidTrail.scale = scale;
}

- (void) addParticles
{
    _asteroidTrail = (CCParticleSystem *)[CCBReader load:@"AsteroidTrail"];
    // make the particle effect clean itself up, once it is completed
    //_asteroidTrail.autoRemoveOnFinish = TRUE;

    _asteroidTrail.particlePositionType = CCParticleSystemPositionTypeFree;
    _asteroidTrail.opacity = 0.5f;
    [[self physicsNode] addChild:_asteroidTrail z:-1];
    

}

- (void) resetParticles
{
    [_asteroidTrail stopSystem];
    [_asteroidTrail resetSystem];
    [_asteroidTrail stopAllActions];
    [_asteroidTrail removeFromParentAndCleanup:YES];
      _asteroidTrail = nil;
    [_asteroidTrail setVisible:NO];

 //   [[self physicsNode]removeChild:_asteroidTrail cleanup:YES];
}
@end
