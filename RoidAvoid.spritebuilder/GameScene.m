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
    
    //Resets all the variables to start a new game
    
    if  ((singleton.firstGame == YES)) {
        [self setupScene];
    }
}

#pragma mark Setup

- (void) setupScene
{
    self->heroMovement = MOVE_STILL;
    self.userInteractionEnabled = TRUE;
    self.multipleTouchEnabled = TRUE;
    physicsNode.debugDraw = NO;
    if (physicsNode.collisionDelegate == Nil)
        physicsNode.collisionDelegate = self;
    
    physicsNode.sleepTimeThreshold = 10.0f;
    physicsNode.gravity = ccp(0,0);
    
    singleton.firstGame = NO;
    singleton.score = 0;
    
    asteroids = [NSMutableArray array];
    gravityBodies = [NSMutableArray array];

    [self displayHighScore];
    [self setPlanet];
    [self setHero];
    [self setStars];
    NSLog(@"Setup Scene");
    
}

- (void) displayHighScore
{
    int highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"] intValue ];
    [highScoreLabel setString:[NSString stringWithFormat:@"%d",highScore]];
}

- (void) setPlanet
{
    earth = (Planet *)[CCBReader load:@"Earth"];
    earth.gravityStrength = EARTH_GRAVITY;
    [physicsNode addChild:earth];
    [gravityBodies addObject:earth];
}

- (void) setHero
{
    if (hero == Nil) {
        hero = (Hero *)[CCBReader load:@"Hero"];
        [physicsNode addChild:hero z:-100.0f];
    }
    heroAngle = HERO_INITIAL_ANGLE;
    [self updateHeroToRotation];
}

- (void) setStars
{
    CCPositionType type;
    type.xUnit = CCPositionUnitNormalized;
    type.yUnit = CCPositionUnitNormalized;

    for (int i = 0; i < STARS_COUNT; i++) {
        CCNode *star = [CCBReader load:@"Star"];
        CGPoint position = CGPointMake(frandom_range(0.0f, 1.0f), frandom_range(0.0f, 1.0f));
        star.positionType = type;
        star.position = position;
        [self addChild:star z:-1.0f];
    }
    bgColor.zOrder = -1001.0f;
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
    [self applyGravity:dt];
    [self moveHero:dt];
}

- (void) applyGravity:(float) dt
{
    for (Planet *gravityBody in gravityBodies) {
        float gravityMultiplier = gravityBody.gravityStrength;
        //NSLog(@"gravityBody x:%f y:%f", gravityBody.position.x, gravityBody.position.y);
        for (Asteroid* roid in asteroids) {
            CCPhysicsBody *physicsBody = roid.physicsBody;
            CGPoint distanceVector = ccpSub(gravityBody.position, roid.position);
            float distance = powf(distanceVector.x, 2) + powf(distanceVector.y, 2);
            //float angle = atan2f(distanceVector.y, distanceVector.x);
            //NSLog(@"affectedByGravity x:%f y:%f α:%f r:%f", roid.position.x, roid.position.y, angle, distance);
            [physicsBody applyForce: ccpMult(distanceVector, dt * gravityMultiplier / powf(distance, 2))];
        }
    }
}

- (void) genAsteroids
{
    curTime = CACurrentMediaTime();
    if (curTime > nextFallTime) {
        //Sets Next Fall time and interval, procedurally decrease by _score
        
        float fallIntervalMin = 3.8 - log10f(singleton.score);
        if (fallIntervalMin < 0)
            fallIntervalMin = 0.15;
        float fallIntervalMax = fallIntervalMin * 1.5;
        float radius = ASTEROID_SPAWN_RADIUS;
        
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
    Asteroid *roid = (Asteroid *)[CCBReader load:[NSString stringWithFormat:@"asteroid_%i",variation]];
    roid.position = position;
   	[asteroids addObject:roid];
    
	[physicsNode addChild:roid];
}


#pragma mark Collision

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair planet:(CCNode *)planet asteroid:(CCNode *)asteroid
{
    //Add Crater
    
    CCNode *crater = [CCBReader load:@"Crater"];
//    CGPoint collisionVelocity = asteroid.physicsBody.velocity;
//    float collisionAngle = ccpToAngle(collisionVelocity);
//    CGPoint collisionOffset = ccpMult(ccp(cosf(collisionAngle),sinf(collisionAngle)),0.5f);
//    crater.rotation = (collisionAngle+3.14159/4)/3.14159*180;
//    crater.position= ccpAdd(collisionOffset, ccpMult(collisionVelocity, 1));
    
    
    [physicsNode addChild:crater z:10];
    [self positionNodeOnEarth:crater atAngle:ccpToAngle(asteroid.position) atHeight:CRATER_STAND_HEIGHT];
    
    CCActionFiniteTime *fadeOut = [CCActionFadeOut actionWithDuration:1.5f];
    CCActionRemove *action = [CCActionRemove action];
    [crater runAction:[CCActionSequence actionWithArray:@[fadeOut,action]]];
    
    
    //Play Sound
    [[OALSimpleAudio sharedInstance]playEffect:@"thud.caf"];
    
    [asteroids removeObject:asteroid];
    [physicsNode removeChild:asteroid cleanup:YES];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero asteroid:(CCNode *)asteroid
{
    NSLog(@"GameOver");
    [self handleGameOver];
}

#pragma mark Transition

- (void) handleGameOver
{
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
}


- (void) handlePauseGame
{
    // [self pauseActions];
    //Plays game over screen at on the same layer
    
    CCScene *pauseScene = [CCBReader loadAsScene:@"PauseScene"];
    
    // And add it to the game scene
    [[CCDirector sharedDirector] pushScene:pauseScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

#pragma mark User Interaction

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:earth];
    if (touchLocation.x > earth.contentSize.width / 2.0f) {
        self->heroMovement = MOVE_RIGHT;
        ((CCSprite *)hero).flipX = TRUE;
    }
    else {
        self->heroMovement = MOVE_LEFT;
        ((CCSprite *)hero).flipX = FALSE;
    }
}

- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches end
    [self releaseMovement];
}

- (void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled
    [self releaseMovement];
}

- (void) releaseMovement
{
    self->heroMovement = MOVE_STILL;
}

- (void) moveHero:(CCTime) dt
{
    heroAngle += dt * self->heroMovement * HERO_MOVE_SPEED;
    [self updateHeroToRotation];
}



@end
