//
//  Asteroid.h
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Singleton.h"

@interface Asteroid : CCSprite {
    CGSize winSize;
    Singleton *singleton;
    CCParticleSystem *_asteroidTrail;
}

@property (readwrite,nonatomic) CCParticleSystem *asteroidTrail;

@end
