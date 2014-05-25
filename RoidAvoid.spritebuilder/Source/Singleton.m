//
//  Singleton.m
//  RoidAvoid
//
//  Created by Wilson Zhao on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Singleton.h"



@implementation Singleton

+ (id)sharedManager {
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
