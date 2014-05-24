//
//  OptionScene.m
//  Untitled
//
//  Created by Wilson Zhao on 4/8/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "OptionScene.h"


@implementation OptionScene
- (void) onEnter
{
    
    backgroundVolume.sliderValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BGVolume"]floatValue];
    effectsVolume.sliderValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FXVolume"]floatValue];
}
- (void) pressedBack
{
    [[CCDirector sharedDirector]popSceneWithTransition:[CCTransition transitionFadeWithDuration:0.5f]];

    
}

- (void)pressedResetHighScore
{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"HighScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //Kills the highscore
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"HighScoreBool"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Reset High Score");
    
}

- (void)valueChanged1:(CCSlider *)sender
{
    // Change volume of your sounds
    [[OALSimpleAudio sharedInstance] setEffectsVolume:sender.sliderValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:sender.sliderValue] forKey:@"FXVolume"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)valueChanged2:(CCSlider *)sender
{
    // Change volume of your sounds
    [[OALSimpleAudio sharedInstance] setBgVolume:sender.sliderValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:sender.sliderValue] forKey:@"BGVolume"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
