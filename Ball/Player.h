//
//  Player.h
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

@property (assign, nonatomic) float health;

-(void)takeDamage:(float)damage;

-(void)tryToShoot:(UITouch*)touch;

@end
