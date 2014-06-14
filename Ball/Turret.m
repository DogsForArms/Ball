//
//  Turret.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "Turret.h"

@implementation Turret

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithColor:[UIColor clearColor] size:size])
    {
        
    }
    return self;
}

-(BOOL)canFire
{
    NSLog(@"WARNING: @selector(canFire) must be overriden, without call to super");
    return YES;
}
-(void)fire:(CGPoint)trajectory withProjectile:(SKSpriteNode*)projectile
{
    CGFloat rotation = atan2f(trajectory.y, trajectory.x);
    [self.parent.parent addChild:projectile];
    
    CGPoint turretTipOffset = esMult(CGPointMake(cosf(rotation), sinf(rotation)), self.size.height );
    CGPoint position = esAdd(self.parent.position, self.position);
    
    [projectile setPosition:esAdd(position, turretTipOffset)];
    
    
    self.zRotation = rotation-M_PI/2;
    
    
    
//    NSLog(@"fireing on trajectory %@", NSStringFromCGPoint(trajectory));
}

@end
