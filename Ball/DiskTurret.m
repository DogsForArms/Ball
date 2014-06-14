//
//  DiskTurret.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "DiskTurret.h"
#import "Projectile.h"

@implementation DiskTurret

-(id)init
{
    if (self = [super initWithSize:CGSizeMake(10, 40)])
    {
        self.color = [UIColor redColor];
        self.anchorPoint = CGPointMake(0.5, 0);
    }
    return self;
}

-(BOOL)canFire
{
    return YES;
}
-(void)fire:(CGPoint)trajectory
{
    //arrange
    Projectile *projectile = [[Projectile alloc] initWithColor:[UIColor redColor] size:CGSizeMake(15, 15)];
    
    
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width];
    [projectile.physicsBody setAllowsRotation:NO];
    projectile.physicsBody.affectedByGravity = NO;
    projectile.physicsBody.restitution = 1.0f;
    projectile.physicsBody.linearDamping = 0.2;
    
    
    CGPoint n = esNormalize(trajectory);
    projectile.physicsBody.velocity = CGVectorMake(n.x*300, n.y*300);

    
    SKAction *wait = [SKAction waitForDuration:3];
    SKAction *remove = [SKAction removeFromParent];
    
    [projectile runAction:[SKAction sequence:@[wait, remove]]];

    [super fire:trajectory withProjectile:projectile];
    
}

@end
