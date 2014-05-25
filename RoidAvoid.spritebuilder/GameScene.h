//
//  GameScene.h
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Singleton.h"

#import "Asteroid.h"
#import "Hero.h"

@interface GameScene : CCNode <CCPhysicsCollisionDelegate> {
    CGSize winSize;
    Singleton *singleton;
    CCPhysicsNode *physicsNode;
    CCNode *earth;
    
    NSMutableArray *asteroids;
    
    CCLabelTTF *scoreLabel;
    
    
    
    float timer, nextFallTime,fallInterval,qForFall,currentFallType,asteroidSize,asteroidPosition,fallingSpeed;
    double curTime;
}

@end
