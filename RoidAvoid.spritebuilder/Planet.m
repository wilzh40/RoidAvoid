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
    self.scale = 0.4f;
    
    
    CCPhysicsBody *physicsBody = self.physicsBody;
    
    // This is used to pick which collision delegate method to call, see GameScene.m for more info.
	physicsBody.collisionType = @"planet";
	// This sets up simple collision rules.
	// First you list the categories (strings) that the object belongs to.
	physicsBody.collisionCategories = @[@"planet"];
	// Then you list which categories its allowed to collide with.
	physicsBody.collisionMask = @[@"hero", @"asteroid",@"boundary"];
    

}


@end
