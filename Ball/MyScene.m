//
//  MyScene.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "MyScene.h"
#import "Player.h"

@interface MyScene ()

@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) SKSpriteNode *ball;

@end

@implementation MyScene
@synthesize player;
@synthesize ball;

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {

        [self initPlayer];
        
        [self initBall];
        
        
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:CGPointMake(0, 500)];
        [bezierPath addLineToPoint:CGPointMake(0, 0)];
        [bezierPath addLineToPoint:CGPointMake(self.size.width, 0)];
        [bezierPath addLineToPoint:CGPointMake(self.size.width, 500)];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self.physicsBody setDynamic:NO];
    
        [self.physicsWorld setGravity:CGVectorMake(0, -0.5)];
    }
    return self;
}

-(void)initPlayer
{
    player = [[Player alloc] init];
    player.position = CGPointMake(self.size.width*0.5f, player.size.height*0.5 + 5);
    [self addChild:player];
}

-(void)initBall
{
    
    ball = [[SKSpriteNode alloc] initWithColor:[UIColor purpleColor] size:CGSizeMake(44, 44)];
    ball.position = CGPointMake(self.size.width*0.5f, self.size.height-44-7);
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:31];
    [ball.physicsBody setAllowsRotation:YES];
    ball.physicsBody.affectedByGravity = YES;
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.mass = 0.005;
    
    [self addChild:ball];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [player tryToShoot:[touches anyObject]];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
