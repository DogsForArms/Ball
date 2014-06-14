//
//  JoinViewController.m
//  Ball
//
//  Created by Ethan Sherr on 6/12/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import "JoinViewController.h"
#import "MatchmakingClient.h"

@interface JoinViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MatchmakingClientDelegate>
@property (nonatomic, weak) IBOutlet UILabel *headingLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *waitView;
@property (nonatomic, strong) IBOutlet UILabel *waitLabel;
@end


@implementation JoinViewController
{
    MatchmakingClient *_matchmakingClient;
    QuitReason _quitReason;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _nameTextField.delegate = self;
    
    
    _waitView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_waitView setBackgroundColor:[UIColor whiteColor]];
    UILabel *connectingLabel = [[UILabel alloc] initWithFrame:_waitView.bounds];
    [connectingLabel setTextAlignment:NSTextAlignmentCenter];
    [connectingLabel setTextColor:[UIColor blackColor]];
    [connectingLabel setText:@"Esstablurshing coNneption..."];
    [_waitView addSubview:connectingLabel];
    _waitLabel = connectingLabel;
    _waitView.alpha = 0.0f;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_matchmakingClient == nil)
    {
        _quitReason = QuitReasonConnectionDropped;
    }
    
	if (!_matchmakingClient)
	{
		_matchmakingClient = [[MatchmakingClient alloc] init];
		[_matchmakingClient startSearchingForServersWithSessionID:kSESSION_ID];
        _matchmakingClient.delegate = self;
        
        NSLog(@"client name is %@", _matchmakingClient.session.displayName);
		self.nameTextField.placeholder = _matchmakingClient.session.displayName;
		[self.tableView reloadData];
	}
    
}




- (IBAction)cnacel:(id)sender
{
   
    _quitReason = QuitReasonUserQuit;
    [_matchmakingClient disconnectFromServer];
    [self.delegate joinViewControllerDidCancel:self];
    
}

#pragma mark uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if (_matchmakingClient != nil)
	{
		[self.view addSubview:self.waitView];
        
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{self.waitView.alpha = 1.0f;} completion:^(BOOL finishd){}];
        
		NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
		[_matchmakingClient connectToServerWithPeerID:peerID];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int n = 0;
	if (_matchmakingClient != nil)
    {
		n = [_matchmakingClient availableServerCount];
    }
    
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingClient displayNameForPeerID:peerID];
    
	return cell;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}
#pragma mark matchmakingclientdelegate
- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID
{
	[self.tableView reloadData];
}
- (void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID
{
	_matchmakingClient.delegate = nil;
	_matchmakingClient = nil;
	[self.tableView reloadData];
	[self.delegate joinViewController:self didDisconnectWithReason:_quitReason];
}

- (void)matchmakingClientNoNetwork:(MatchmakingClient *)client
{
	_quitReason = QuitReasonNoNetwork;
}
- (void)matchmakingClient:(MatchmakingClient *)client didConnectToServer:(NSString *)peerID
{
	NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([name length] == 0)
		name = _matchmakingClient.session.displayName;
    
	[self.delegate joinViewController:self startGameWithSession:_matchmakingClient.session playerName:name server:peerID];
}

@end
