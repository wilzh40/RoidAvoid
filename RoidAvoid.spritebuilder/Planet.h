//
//  Planet.h
//  RoidAvoid
//
//  Created by Paul Merrill on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Planet : CCSprite

@property (readwrite,nonatomic) float gravityStrength;

@end
