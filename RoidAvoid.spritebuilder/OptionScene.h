//
//  OptionScene.h
//  Untitled
//
//  Created by Wilson Zhao on 4/8/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Singleton.h"
#import <CoreMotion/CoreMotion.h>
@interface OptionScene : CCNode <UIAccelerometerDelegate>{
    CCSlider *backgroundVolume, *effectsVolume;
    Singleton *singleton;
    CGPoint calibrationVector;
}

@end
