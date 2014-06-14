//
//  Constants.h
//  Kitty Defence
//
//  Created by Ethan Sherr on 2/17/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Constants <NSObject>
//uint32_t
//#define RatRocketCategory       0x1 <<1
//#define CatGymCategory          0x1 <<2
//#define GroundCategory          0x1 <<3
//#define RedExplosionCategory    0x1 <<4
//#define DogCarCategory          0x1 <<5
//#define SceneBoundaryCategory   0x1 <<6
//#define ButterflyCategory       0x1 <<7


#define kNAME_PLAYER @"player"

#define kSESSION_ID @"wooee"

typedef enum
{
	QuitReasonNoNetwork,          // no Wi-Fi or Bluetooth
	QuitReasonConnectionDropped,  // communication failure with server
	QuitReasonUserQuit,           // the user terminated the connection
	QuitReasonServerQuit,         // the server quit the game (on purpose)
}
QuitReason;

@end
