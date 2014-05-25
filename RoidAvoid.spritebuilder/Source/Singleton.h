//
//  Singleton.h
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    int _score;
    bool _firstGame;
}
+ (id)sharedManager;

@property (readwrite,nonatomic) int score;
@property (readwrite,nonatomic) bool firstGame;
@end
