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
        float convConstant = 3.141592653589/180;
        float angleOffsetRange = 20;
        float angleOffset = 0;
        float scale = frandom_range(0.1f, 0.2f);
        self.scale = scale;
        CGPoint asteroidPos = singleton.asteroidPos;
        
        float angle = (ccpToAngle(asteroidPos))/convConstant;
        
        
        while (fabsf(angleOffset) < angleOffset/2) {
        angleOffset = frandom_range(-angleOffsetRange, angleOffsetRange);
        }
        float newAngle =+ angleOffset;
        
        float speed = frandom_range(0.5f,0.7f);
        CCPhysicsBody *physicsBody = self.physicsBody;
        [physicsBody setVelocity:ccpMult(ccp(cosf(newAngle),sinf(newAngle)), -speed)];
        
    
        

        
        
    

    NSLog(@"%f",angle);
}

@end
