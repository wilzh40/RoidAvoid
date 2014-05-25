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

enum HeroMovement {
    MOVE_RIGHT = -1,
    MOVE_STILL,
    MOVE_LEFT,
};

@interface GameScene : CCNode <CCPhysicsCollisionDelegate> {
    CGSize winSize;
    Singleton *singleton;
    CCPhysicsNode *physicsNode;
    CCNode *earth;
    CCNode *hero;
    float heroAngle;
    enum HeroMovement heroMovement;
    CCNode *bgColor;
    
    NSMutableArray *asteroids, *gravityBodies;
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *highScoreLabel;
    
    
    
    float timer, nextFallTime,fallInterval,qForFall,currentFallType,asteroidSize,asteroidPosition,fallingSpeed;
    double curTime;
}

@end
