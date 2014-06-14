//
//  Turret.h
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Turret : SKSpriteNode

-(id)initWithSize:(CGSize)size;

//must implement these
-(void)fire:(CGPoint)trajectory;
-(BOOL)canFire;


//super method
-(void)fire:(CGPoint)trajectory withProjectile:(SKSpriteNode*)projectile;


@property (assign, nonatomic, readonly) NSInteger ammo;


@end
