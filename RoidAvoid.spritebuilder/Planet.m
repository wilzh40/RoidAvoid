//
//  Planet.m
//  RoidAvoid
//
//  Created by Paul Merrill on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Planet.h"

@implementation Planet

- (void) onEnter
{
    [self setVars];
	[super onEnter];
}

- (void) setVars
{
    for (CCNode *child in self.children) {
        child.scale = 1.5f;
    }
    
}

@end
