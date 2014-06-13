//
//  GameScene.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "CCEffect.h"
#import "CCEffectGaussianBlur.h"
@implementation GameScene

- (void) onEnter
{
    singleton = [Singleton sharedManager];
    winSize = [[CCDirector sharedDirector]viewSize];
    
	
	[super onEnter];
    
    //Resets all the variables to start a new game
    
    // if  ((singleton.firstGame == YES)) {
    [self setupScene];
    // }
}

- (void) onExit
{
    [_motionManager startAccelerometerUpdates];
    [[OALSimpleAudio sharedInstance] playBg:@"Piano.m4a" loop:YES];
    [super onExit];
	
}

#pragma mark Setup

- (void) setupScene
{
    self->heroMovement = MOVE_STILL;
    if (singleton.controlScheme == kTouch) {
        self.userInteractionEnabled = TRUE;
    }
    
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
    asteroidTrails = [NSMutableArray array];
    
    _motionManager = [[CMMotionManager alloc]init];
    [_motionManager startAccelerometerUpdates];
    
    [[OALSimpleAudio sharedInstance] playBg:@"Jazz.mp3" loop:YES];
    
    back.visible = NO;
    back.userInteractionEnabled = NO;
    
    [self displayHighScore];
    [self setPlanet];
    [self setHero];
    // [self setStars];
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
        [physicsNode addChild:hero z:5];
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


#pragma mark Scheduler
- (void) update:(CCTime) dt
{
    singleton.score++;
    [scoreLabel setString:[NSString stringWithFormat:@"%d",singleton.score]];
    
    //some simple testing code
    [self genAsteroids];
    [self applyGravity:dt];
    [self moveHero:dt];
    [self updateParticles];
    [self updateAccelerometer];
    
    [singleton chooseEvent:kWildCard];
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

- (void) applyGravity:(float) dt
{
    for (Planet *gravityBody in gravityBodies) {
        float gravityMultiplier = gravityBody.gravityStrength;
        //NSLog(@"gravityBody x:%f y:%f", gravityBody.position.x, gravityBody.position.y);
        for (Asteroid* roid in asteroids) {
            CCPhysicsBody *physicsBody = roid.physicsBody;
            CGFloat mass = physicsBody.mass;
            CGPoint distanceVector = ccpSub(gravityBody.position, roid.position);
            float distance = powf(distanceVector.x, 2) + powf(distanceVector.y, 2);
            //float angle = atan2f(distanceVector.y, distanceVector.x);
            //NSLog(@"affectedByGravity x:%f y:%f α:%f r:%f", roid.position.x, roid.position.y, angle, distance);
            [physicsBody applyForce: ccpMult(distanceVector, dt * mass * gravityMultiplier / powf(distance, 2))];
        }
    }
}

- (void) genAsteroids
{
    curTime = CACurrentMediaTime();
    
    if (curTime > nextFallTime) {
        if (singleton.asteroidEvent == kNormal) {
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
            //float randomY = frandom_range(winSize.height, winSize.height + logf(_score));
            //CGPoint startingPosition = ccp(CCRANDOM_ON_UNIT_CIRCLE().x*radius+winSize.width/2,CCRANDOM_IN_UNIT_CIRCLE().x*radius+winSize.height/2);
            CGPoint circle = ccpMult(CCRANDOM_ON_UNIT_CIRCLE(), radius);
            CGPoint startingPosition = ccp(circle.x,circle.y);
            [self genAsteroid:startingPosition];
        }
        if (singleton.asteroidEvent == kShower) {
            
            float fallIntervalMin = 0.5 - log10f(singleton.score);
            if (fallIntervalMin < 0)
                fallIntervalMin = 0.05;
            float fallIntervalMax = fallIntervalMin * 1.2;
            float radius = ASTEROID_SPAWN_RADIUS;
            
            fallInterval = fabsf(frandom_range(fallIntervalMin,fallIntervalMax));
            nextFallTime = curTime + 3.0f;
            
            int direction = random_range(1, 4);
            int increment = random_range(8, 12);
            CGPoint startingPosition;
            for (int i = 0; i<increment; i++) {
                switch (direction) {
                    case 1:
                        startingPosition = ccp(winSize.width/increment*i, ASTEROID_SPAWN_RADIUS);
                        break;
                    case 2:
                        startingPosition = ccp(winSize.width/increment*i, -ASTEROID_SPAWN_RADIUS);
                        break;
                    case 3:
                        startingPosition = ccp(-ASTEROID_SPAWN_RADIUS, winSize.height/increment*i);
                        break;
                    case 4:
                        startingPosition = ccp(ASTEROID_SPAWN_RADIUS, winSize.height/increment*i);
                        break;
                    default:
                        break;
                }
                [self genAsteroid:startingPosition];
            }
            
            [singleton chooseEvent:kNormal];
            
            
        }
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

- (void) updateParticles
{
    for (Asteroid *n in asteroids){
        n.asteroidTrail.position = n.position;
        [n.asteroidTrail setScale:n.scale];
        //[n.asteroidTrail setOpacity:0.0f];
    }
}

#pragma mark Collision

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair planet:(CCNode *)planet asteroid:(Asteroid *)asteroid
{
    //Remove Trail
    [asteroid resetParticles];
    
    //Add Crater
    
    CCNode *crater = [CCBReader load:@"Crater"];
    [physicsNode addChild:crater z:10];
    
    [self positionNodeOnEarth:crater atAngle:ccpToAngle(asteroid.position) atHeight:CRATER_STAND_HEIGHT];
    
    CCActionFiniteTime *fadeOut = [CCActionFadeOut actionWithDuration:1.5f];
    CCActionRemove *action = [CCActionRemove action];
    [crater runAction:[CCActionSequence actionWithArray:@[fadeOut,action]]];
    
    //Play Sound
    
    [[OALSimpleAudio sharedInstance]playEffect:@"thud.caf"];
    
    
    [asteroids removeObject:asteroid];
    [asteroid.asteroidTrail resetSystem];
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
    
    //CCScene *pauseScene = [CCBReader loadAsScene:@"PauseScene"];
    
    // And add it to the game scene
    //[[CCDirector sharedDirector] pushScene:pauseScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
    
    // Displays a blurred background
    [singleton storeBlurredSprite:self];
    blurredSprite = singleton.blurredSprite;
 
    [self addChild:blurredSprite];

    back.zOrder = 100;
    back.visible = YES;
    back.userInteractionEnabled = YES;

    self.paused = true;
    
}

- (void) handleResumeGame
{
    [self removeChild:blurredSprite];
    back.visible = NO;
    back.userInteractionEnabled = NO;
    
    self.paused = false;
    
    
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

    [self releaseMovement];
}

- (void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
   
    [self releaseMovement];
}

- (void) releaseMovement
{
    self->heroMovement = MOVE_STILL;
}

- (void) updateAccelerometer
{
    if (singleton.controlScheme == kAccelerometer) {
        
        float unitCircle = 360;
        float halfCircle = 180;
        
        CGPoint calibrationVector = singleton.calibrationVector;
        CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
        CMAcceleration acceleration = accelerometerData.acceleration;
        float  tiltAngle = (-ccpToAngle( ccpSub( ccp( acceleration.y, acceleration.x ), calibrationVector )));
        float tolerance = ACCELEROMETER_TOLERANCE;
        
        //Converted radians to degrees
        
        int  newHeroAngle = heroAngle/3.14159*180;
        int  newTiltAngle = tiltAngle/3.14159*180;
        
        //Scaled it from -180 to 180 + 2*PI*N -> 0 to 360
        
        newTiltAngle = newTiltAngle < 0 ? newTiltAngle + unitCircle*2 : newTiltAngle;
        newHeroAngle = (newHeroAngle < 0 ? newHeroAngle + unitCircle*2 : newHeroAngle);
        float angleDiff = newHeroAngle % 360 - newTiltAngle % 360;
        
        //If the angle difference isn't high enough then the dinosaur stays still
        
        if ((int)fabs(angleDiff)%360 < tolerance ) {
            self->heroMovement = MOVE_STILL;
        }
        
        //Code for looping the dinosaur around the circle when the angle difference is high but the distance is close
        
        else if ((angleDiff > 0 && angleDiff < halfCircle) || (angleDiff < 0 && angleDiff < -halfCircle)) {
            self->heroMovement = MOVE_RIGHT;
            ((CCSprite *)hero).flipX = TRUE;
        }
        else {
            self->heroMovement = MOVE_LEFT;
            ((CCSprite *)hero).flipX = FALSE;
        }

    }
}




- (void) moveHero:(CCTime) dt
{
    
    heroAngle += dt * self->heroMovement * HERO_MOVE_SPEED;
    [self updateHeroToRotation];
}



@end
