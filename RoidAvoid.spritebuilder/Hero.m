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
    self.scale = 2.0f;
    
    CCPhysicsBody *physicsBody = self.physicsBody;
    
    // This is used to pick which collision delegate method to call, see GameScene.m for more info.
	physicsBody.collisionType = @"hero";
	// This sets up simple collision rules.
	// First you list the categories (strings) that the object belongs to.
	physicsBody.collisionCategories = @[@"hero"];
	// Then you list which categories its allowed to collide with.
	physicsBody.collisionMask = @[@"hero", @"planet",@"boundary",@"asteroid"];
    

}

@end
