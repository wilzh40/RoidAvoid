//
//  GameScene.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

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
    self->heroMovement = MOVE_STILL;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
    physicsNode.debugDraw = NO;
    if (physicsNode.collisionDelegate == Nil) physicsNode.collisionDelegate = self;
    physicsNode.sleepTimeThreshold = 10.0f;
    physicsNode.gravity = ccp(0,0);
    singleton.firstGame = NO;
    singleton.score = 0;
    asteroids = [NSMutableArray array];
    gravityBodies = [NSMutableArray array];
    
    [self setPlanet];
    [self setHero];
    NSLog(@"Setup Scene");
    
}

- (void) setPlanet
{
    if (earth == Nil) {
        earth = [CCBReader load:@"Earth"];
        [physicsNode addChild:earth];
        [gravityBodies addObject:earth];
    }
}

- (void) setHero
{
    if (hero == Nil) {
        hero = [CCBReader load:@"Hero"];
        [physicsNode addChild:hero z:-100.0f];
    }
    heroAngle = HERO_INITIAL_ANGLE;
    [self updateHeroToRotation];
}

- (void) updateHeroToRotation
{
    [self positionNodeOnEarth:hero atAngle:heroAngle atHeight:HERO_STAND_HEIGHT];
}

- (void) positionNodeOnEarth:(CCNode *)node atAngle:(float)angle atHeight:(float)height
{
    CGPoint position = CGPointMake(cos(angle), sin(angle));
    position = ccpMult(position, height);
    node.position = position;
    node.rotation = 90 - angle / 3.14f * 180.0f;
}

#pragma mark Scheduler
- (void) update:(CCTime) dt
{
    singleton.score++;
    [scoreLabel setString:[NSString stringWithFormat:@"%d",singleton.score]];
    
    //some simple testing code
    [self genAsteroids];
    [self applyGravity];
    [self moveHero:dt];
}

- (void) applyGravity
{

    float gravityMultiplier = GRAVITY_CONSTANT;
    for (CCNode *gravityBody in gravityBodies) {
        //NSLog(@"gravityBody x:%f y:%f", gravityBody.position.x, gravityBody.position.y);
        for (CCNode* child in physicsNode.children) {
            CCPhysicsBody *physicsBody = child.physicsBody;
            if (!physicsBody.affectedByGravity) {
                continue;
            }
            CGPoint distanceVector = ccpSub(gravityBody.position, child.position);
            float distance = powf(distanceVector.x, 2) + powf(distanceVector.y, 2);
            float angle = atan2f(distanceVector.y, distanceVector.x);
            //NSLog(@"affectedByGravity x:%f y:%f α:%f r:%f", child.position.x, child.position.y, angle, distance);
            [physicsBody applyForce: ccpMult(distanceVector, gravityMultiplier / powf(distance, 2))];
        }
    }
}

- (void) genAsteroids
{
    curTime = CACurrentMediaTime();
    if (curTime > nextFallTime) {
        //Sets Next Fall time and interval, procedurally decrease by _score
        
        float fallIntervalMin = 5 - log10f(singleton.score)/0.5;
        float fallIntervalMax = 6 - log10f(singleton.score)/1;
        float radius = 300;
        
        fallInterval = fabsf(frandom_range(fallIntervalMin,fallIntervalMax));
        
        //NSLog(@"min %f max %f interval %f",fallIntervalMin, fallIntervalMax,fallInterval);
        
        nextFallTime = fallInterval + curTime;
        //singleton.asteroidX = frandom_range(-winSize.width/4, winSize.width/4);
        //loat randomY = frandom_range(winSize.height, winSize.height + logf(_score));
        //CGPoint startingPosition = ccp(CCRANDOM_ON_UNIT_CIRCLE().x*radius+winSize.width/2,CCRANDOM_IN_UNIT_CIRCLE().x*radius+winSize.height/2);
        CGPoint circle = ccpMult(CCRANDOM_ON_UNIT_CIRCLE(), radius);
        CGPoint startingPosition = ccp(circle.x,circle.y);
        [self genAsteroid:startingPosition];
    }
}

- (void) genAsteroid:(CGPoint)position
{
    int variation = random_range(1, 5);
    CCNode *rock = [CCBReader load:[NSString stringWithFormat:@"asteroid_%i",variation]];
    rock.position = position;
    singleton.asteroidPos = position;
   	[asteroids addObject:rock];
    
	[physicsNode addChild:rock];
}


#pragma mark Collision

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair planet:(CCNode *)planet asteroid:(CCNode *)asteroid
{
    [asteroids removeObject:asteroid];
    [physicsNode removeChild:asteroid cleanup:YES];
    
    //Add Crater
    
    CCNode *crater = [CCBReader load:@"Crater"];
    CGPoint collisionPoint = asteroid.position;
    
    //Play Sound
    [[OALSimpleAudio sharedInstance]playEffect:@"Thud.wav"];
    
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero asteroid:(CCNode *)asteroid
{
    NSLog(@"GameOver");
    [self handleGameOver];
}
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

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:earth];
    if (touchLocation.x > 0.0f) {
        self->heroMovement = MOVE_RIGHT;
    }
    else {
        self->heroMovement = MOVE_LEFT;
    }
}

- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches end, release the catapult
    [self releaseMovement];
}

- (void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, release the catapult
    [self releaseMovement];
}

- (void) releaseMovement
{
    self->heroMovement = MOVE_STILL;
}

- (void) moveHero:(CCTime) dt
{
    heroAngle += dt * self->heroMovement;
    [self updateHeroToRotation];
}



@end
