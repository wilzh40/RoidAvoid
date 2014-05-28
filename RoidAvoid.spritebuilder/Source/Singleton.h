//
//  Singleton.h
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#pragma mark Useful Macros

#define frandom                 ((float)arc4random()/UINT64_C(0x100000000))
#define frandom_range(low,high) (((high-low)*frandom)+low)
#define random_range(low,high)  ((arc4random()%(high-low+1))+low)
#define RTD(radians) (radian/M_PI*180)

#define ASTEROID_SPAWN_RADIUS (325.0f)

#define ASTEROID_ANGLE_MIN (0.7f)
#define ASTEROID_ANGLE_MAX (0.8f)
#define ASTEROID_ANGLEVELOCITY_MIN (0.1f)
#define ASTEROID_ANGLEVELOCITY_MAX (0.3f)
#define ASTEROID_SIZE_MIN (0.1f)
#define ASTEROID_SIZE_MAX (0.2f)
#define ASTEROID_SPEED_MIN (15.f)
#define ASTEROID_SPEED_MAX (22.f)

#define ASTEROID_OUTLIER_PROB (0.1f)

#define ASTEROID_OUTLIER_ANGLE_MIN (0.7f)
#define ASTEROID_OUTLIER_ANGLE_MAX (0.8f)
#define ASTEROID_OUTLIER_ANGLEVELOCITY_MIN (0.5f)
#define ASTEROID_OUTLIER_ANGLEVELOCITY_MAX (1.0f)
#define ASTEROID_OUTLIER_SIZE_MIN (0.2f)
#define ASTEROID_OUTLIER_SIZE_MAX (0.4f)
#define ASTEROID_OUTLIER_SPEED_MIN (18.f)
#define ASTEROID_OUTLIER_SPEED_MAX (25.f)

#define EARTH_GRAVITY (6.0f * 1000.0f * 1000.0f * 1000.0f)

#define CRATER_STAND_HEIGHT (47.0f)

#define HERO_INITIAL_ANGLE (M_PI_2)
#define HERO_MOVE_SPEED (2.0f)
#define HERO_STAND_HEIGHT (64.0f)

#define ACCELEROMETER_TOLERANCE (10.0f)


#define STARS_COUNT (100)

@interface Singleton : NSObject {
    int _score;
    bool _firstGame;
    
    CGPoint _calibrationVector;
    
    CMMotionManager *_motionManager;
}

+ (id)sharedManager;

@property (readwrite,nonatomic) int score;
@property (readwrite,nonatomic) bool firstGame;

@property (readwrite,nonatomic) CGPoint asteroidPos;
@property (readwrite,nonatomic) CGPoint calibrationVector;

@end
