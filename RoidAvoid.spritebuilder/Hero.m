//
//  Hero.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Hero.h"


@implementation Hero

- (void) onEnter
{
    [self setVars];
	[super onEnter];
}

- (void) setVars
{
    for (CCNode *child in self.children) {
        child.scale = 2.0f;
    }
}

@end
