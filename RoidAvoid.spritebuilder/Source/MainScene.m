//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void) pressedPlay
{
    CCScene *scene = [CCBReader loadAsScene:@"GameScene"];
    
    [[CCDirector sharedDirector]pushScene:scene withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    
    
}

- (void) pressedOptions
{
    CCScene *scene = [CCBReader loadAsScene:@"OptionScene"];
    
    [[CCDirector sharedDirector]pushScene:scene withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    
    
}

- (void) pressedCredits
{
    CCScene *scene = [CCBReader loadAsScene:@"CreditsScene"];
    [[CCDirector sharedDirector]pushScene:scene withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}


@end
