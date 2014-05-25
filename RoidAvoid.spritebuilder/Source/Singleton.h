//
//  Singleton.h
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Useful Macros

#define frandom (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low
#define random_range(low,high) (arc4random()%(high-low+1))+low
#define RTD(radians) (radian/3.14159*180)
@interface Singleton : NSObject {
    int _score;
    bool _firstGame;
}
+ (id)sharedManager;

@property (readwrite,nonatomic) int score;
@property (readwrite,nonatomic) bool firstGame;
@property (readwrite,nonatomic) CGPoint asteroidPos;
@end
