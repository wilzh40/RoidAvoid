//
//  GameScene.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene
#pragma mark Useful Macros

#define frandom (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low
#define random_range(low,high) (arc4random()%(high-low+1))+low

- (void) onEnter
{
    
    singleton = [Singleton sharedManager];
    winSize = [[CCDirector sharedDirector]viewSize];
	
	[super onEnter];
    
    
    if  ((singleton.firstGame == YES)) {
        [self setupScene];
    }
    [self setupScene];
    
}

#pragma mark Setup

- (void) setupScene
{
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
    physicsNode.debugDraw = NO;
    if (physicsNode.collisionDelegate == Nil) physicsNode.collisionDelegate = self;
    physicsNode.sleepTimeThreshold = 10.0f;
    singleton.firstGame = NO;
    
    asteroids = [NSMutableArray array];
    NSLog(@"Setup Scene");
    
}

- (void) setPlanet
{
    
}

- (void) setHero
{
    
}

#pragma mark Scheduler
- (void) update:(CCTime) dt
{
    singleton.score++;
    [scoreLabel setString:[NSString stringWithFormat:@"%d",singleton.score]];
    
    
    //some simple testing code
    [self genAsteroids];
    
}
- (void) genAsteroids
{
    curTime = CACurrentMediaTime();
    if (curTime > nextFallTime) {
        //Sets Next Fall time and interval, procedurally decrease by _score
        
        float fallIntervalMin = 5 - log10f(singleton.score)/0.5;
        float fallIntervalMax = 6 - log10f(singleton.score)/1;
        
        fallInterval = fabsf(frandom_range(fallIntervalMin,fallIntervalMax));
        
        //NSLog(@"min %f max %f interval %f",fallIntervalMin, fallIntervalMax,fallInterval);
        
        nextFallTime = fallInterval + curTime;
        //singleton.asteroidX = frandom_range(-winSize.width/4, winSize.width/4);
        //loat randomY = frandom_range(winSize.height, winSize.height + logf(_score));
        CGPoint startingPosition = ccp(100,200);
        
        [self genAsteroid:startingPosition];
        
        
    }
}
- (void) genAsteroid:(CGPoint)position

{
    
	//CCNode *rock = [CCBReader load:[NSString stringWithFormat:@"asteroid_%i",1]];
    CCNode *rock = [CCBReader load:@"asteroid_1"];
    
    rock.position = position;
    
   	[asteroids addObject:rock];
    
	[physicsNode addChild:rock];
    NSLog(@"Generated Asteroid");
}


#pragma mark Collision

#pragma mark Transition

- (void) handleGameOver {
    
      //Sets score
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:singleton.score] forKey:@"Score"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    int highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"] intValue ];
    
    if (singleton.score>highScore){
        //If score is higher than the highscore, saves the highscore!
        highScore = singleton.score;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScore] forKey:@"HighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // There is a high score in town!
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"HighScoreBool"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    //Plays game over screen at on the same layer
    
    CCScene *GameOverScene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector]replaceScene:GameOverScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
    
    singleton.firstGame = YES;
    
    // And add it to the game scene
    // [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5f scene:GameOverScene withColor:ccc3(0, 0, 0)]];
    
    
    //[self pauseActions];
    
}


- (void) handlePauseGame
{
    // [self pauseActions];
    //Plays game over screen at on the same layer
    
    CCScene *pauseScene = [CCBReader loadAsScene:@"PauseScene"];
    
    // And add it to the game scene
    [[CCDirector sharedDirector] pushScene:pauseScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];

    
    
}


@end
