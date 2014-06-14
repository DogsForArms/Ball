//
//  MainViewController.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "MainViewController.h"

#import "HostViewController.h"
#import "JoinViewController.h"
#import "GameViewController.h"
#import "Game.h"

@interface MainViewController () <HostViewControllerDelegate, JoinViewControllerDelegate, GameViewControllerDelegate>
@property (assign, nonatomic) BOOL buttonsEnabled;

@end

@implementation MainViewController
{
    BOOL _performAnimations;
}

- (IBAction)hostAction:(id)sender
{
    
        if (_buttonsEnabled)
        {
         
                 HostViewController *hostViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HostViewController"];
                 hostViewController.delegate = self;
                 
                 [self presentViewController:hostViewController animated:YES completion:nil];
            
        }
    
}
- (IBAction)joinAction:(id)sender
{
    if (_buttonsEnabled)
    {
        JoinViewController *joinViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JoinViewController"];
        joinViewController.delegate = self;
        
        [self presentViewController:joinViewController animated:YES completion:nil];
    }
    
}

-(void)joinViewControllerDidCancel:(JoinViewController*)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)hostViewControllerDidCancel:(HostViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _buttonsEnabled = YES;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)joinViewController:(JoinViewController *)controller didDisconnectWithReason:(QuitReason)reason
{
    if (reason == QuitReasonNoNetwork)
    {
        [self showNoNetworkAlert];
    }
    else if (reason == QuitReasonConnectionDropped)
    {
        [self dismissViewControllerAnimated:NO completion:^
         {
             [self showDisconnectedAlert];
         }];
    }
}

- (void)hostViewController:(HostViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
	_performAnimations = NO;
    
	[self dismissViewControllerAnimated:NO completion:^
     {
         _performAnimations = YES;
         
         [self startGameWithBlock:^(Game *game)
          {
              [game startServerGameWithSession:session playerName:name clients:clients];
          }];
     }];
}

- (void)joinViewController:(JoinViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
	_performAnimations = NO;
    
	[self dismissViewControllerAnimated:NO completion:^
     {
         _performAnimations = YES;
         
         [self startGameWithBlock:^(Game *game)
          {
              [game startClientGameWithSession:session playerName:name server:peerID];
          }];
     }];
}

- (void)startGameWithBlock:(void (^)(Game *))block
{
	GameViewController *gameViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil ] instantiateViewControllerWithIdentifier:@"GameViewController"];
	
    gameViewController.delegate = self;
    
	[self presentViewController:gameViewController animated:NO completion:^
     {
         Game *game = [[Game alloc] init];
         gameViewController.game = game;
         game.delegate = gameViewController;
         block(game);
     }];
}

- (void)showNoNetworkAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"No Network", @"No network alert title")
                              message:NSLocalizedString(@"To use multiplayer, please enable Bluetooth or Wi-Fi in your device's Settings.", @"No network alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}

- (void)showDisconnectedAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Disconnected", @"Client disconnected alert title")
                              message:NSLocalizedString(@"You were disconnected from the game.", @"Client disconnected alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}


- (void)hostViewController:(HostViewController *)controller didEndSessionWithReason:(QuitReason)reason
{
	if (reason == QuitReasonNoNetwork)
	{
		[self showNoNetworkAlert];
	}
}

#pragma mark gameviewcontrollerdelegate
- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason
{
	[self dismissViewControllerAnimated:NO completion:^
     {
         if (reason == QuitReasonConnectionDropped)
         {
             [self showDisconnectedAlert];
         }
     }];
}
@end
