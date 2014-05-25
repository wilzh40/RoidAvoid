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
    for (CCNode *children in self.children) {
        float convConstant = 3.141592653589/180;
        float angleOffsetRange = 20;
        float angleOffset = 0;
        float scale = frandom_range(0.1f, 0.2f);
        children.scale = scale;
        CGPoint asteroidPos = singleton.asteroidPos;
        
        float angle = (ccpToAngle(asteroidPos))/convConstant;
        
        
        while (fabsf(angleOffset) < angleOffset/2) {
        float angleOffset = frandom_range(-angleOffsetRange, angleOffsetRange);
        }
        float newAngle =+ angleOffset;
        
        float speed = frandom_range(0.5f,0.7f);
        CCPhysicsBody *physicsBody = children.physicsBody;
        [physicsBody setVelocity:ccpMult(ccp(sinf(newAngle),cosf(newAngle)), -speed)];
        
        NSLog(@"%f",angle);
        

        
        
        


    }
}

@end
