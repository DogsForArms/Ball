//
//  Player.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "Player.h"
#import "Turret.h"
#import "DiskTurret.h"
@interface Player ()

@property (strong, nonatomic) NSMutableArray *turretWeapons;
@property (assign, nonatomic) NSInteger turretIndex;

@end

@implementation Player

@synthesize turretWeapons;
@synthesize turretIndex;


-(id)init
{
    if (self = [super initWithColor:[UIColor blueColor] size:CGSizeMake(100, 80)])
    {
        self.health = 100.0f;
        self.name = kNAME_PLAYER;
        
        [self initializeWeapons];
        
    }
    return self;
}
-(void)initializeWeapons
{
    turretWeapons = [[NSMutableArray alloc] init];
    [turretWeapons addObject:[[DiskTurret alloc] init]];
    
    [self addChild:turretWeapons[turretIndex]];
    
}

-(void)tryToShoot:(UITouch*)touch
{
    CGPoint touchLocation = [touch locationInNode:self];
    if ([[self getTurret] canFire])
    {
        [[self getTurret] fire:touchLocation];
    }
}

-(Turret*)getTurret
{
    return turretWeapons[turretIndex];
}


@end
