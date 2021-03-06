//
//  GameScene.h
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "cocos2d.h"
#import "Singleton.h"

#import "Asteroid.h"
#import "Hero.h"
#import "Planet.h"

enum HeroMovement {
    MOVE_RIGHT = -1,
    MOVE_STILL,
    MOVE_LEFT,
};

@interface GameScene : CCNode <CCPhysicsCollisionDelegate,UIAccelerometerDelegate> {
    CGSize winSize;
    Singleton *singleton;
    CCPhysicsNode *physicsNode;
    Planet *earth;
    Hero *hero;
    float heroAngle;
    enum HeroMovement heroMovement;
    CCNode *bgColor;
    
    NSMutableArray *asteroids, *gravityBodies, *asteroidTrails;
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *highScoreLabel;
    
    CMMotionManager *_motionManager;
    
    float timer, nextFallTime,fallInterval,qForFall,currentFallType,asteroidSize,asteroidPosition,fallingSpeed;
    double curTime;
}

@end
