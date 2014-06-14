//
//  ViewController.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "GameViewController.h"
#import "MyScene.h"

@implementation GameViewController

@synthesize delegate = _delegate;
@synthesize game = _game;

- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (IBAction)exitAction:(id)sender
{
	[self.game quitGameWithReason:QuitReasonUserQuit];
}
- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
	[self.delegate gameViewController:self didQuitWithReason:reason];
}

-(void)viewDidLayoutSubviews
{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)gameWaitingForServerReady:(Game *)game
{
    NSLog(@"%@", NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server"));
//	self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}
- (void)gameWaitingForClientsReady:(Game *)game
{
	NSLog(@"%@", NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients") );
}

@end
