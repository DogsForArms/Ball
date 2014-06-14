//
//  HostGameViewController.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "HostViewController.h"
#import "MatchmakingServer.h"


@interface HostViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MatchmakingServerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *connectTableView;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (assign, nonatomic) BOOL buttonsEnabled;

@end

@implementation HostViewController
{
    MatchmakingServer *_matchmakingServer;
    QuitReason _quitReason;

}


@synthesize textField;
@synthesize connectTableView;
@synthesize startButton;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [textField setDelegate:self];
    _buttonsEnabled = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:textField action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    
    [connectTableView setDelegate:self];
    [connectTableView setDataSource:self];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_matchmakingServer)
    {
        _matchmakingServer = [[MatchmakingServer alloc] init];
        _matchmakingServer.delegate = self;
        _matchmakingServer.maxClients = 2;
        [_matchmakingServer startAcceptingConnectionsForSessionID:kSESSION_ID];
        
        NSLog(@"host session is called %@", _matchmakingServer.session.displayName);
        self.textField.placeholder = _matchmakingServer.session.displayName;
		[self.connectTableView reloadData];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startAction:(id)sender
{
    if (_matchmakingServer != nil && [_matchmakingServer connectedClientCount] > 0)
	{
		NSString *name = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([name length] == 0)
			name = _matchmakingServer.session.displayName;
        
		[_matchmakingServer stopAcceptingConnections];
        
        
        
		[self.delegate hostViewController:self startGameWithSession:_matchmakingServer.session playerName:name clients:_matchmakingServer.connectedClients];
	}
}
- (IBAction)cancel:(id)sender
{
    _quitReason = QuitReasonUserQuit;
	[_matchmakingServer endSession];
	[self.delegate hostViewControllerDidCancel:self];
}

#pragma mark txtfielddelegate callbacks
-(BOOL)textFieldShouldReturn:(UITextField *)tF
{
    [tF resignFirstResponder];
    return YES;
}

#pragma mark UITAbleViewDelegate & DataSource

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_matchmakingServer != nil)
		return [_matchmakingServer connectedClientCount];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [_matchmakingServer peerIDForConnectedClientAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingServer displayNameForPeerID:peerID];
    
	return cell;
}
#pragma mark - MatchmakingServerDelegate


- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
    [self.connectTableView reloadData];
}
- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
    [self.connectTableView reloadData];
}
- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server
{
	_matchmakingServer.delegate = nil;
	_matchmakingServer = nil;
	[self.connectTableView reloadData];
	[self.delegate hostViewController:self didEndSessionWithReason:_quitReason];
}

- (void)matchmakingServerNoNetwork:(MatchmakingServer *)server
{
	_quitReason = QuitReasonNoNetwork;
}


@end
