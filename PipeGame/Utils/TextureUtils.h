//
//  TextureUtils.h
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import <Foundation/Foundation.h>

@interface TextureUtils : NSObject

// arm
FOUNDATION_EXPORT NSString *const kImageNameArmDownLeft;
FOUNDATION_EXPORT NSString *const kImageNameArmDownRight;
FOUNDATION_EXPORT NSString *const kImageNameArmUpLeft;
FOUNDATION_EXPORT NSString *const kImageNameArmUpRight;
FOUNDATION_EXPORT NSString *const kImageNameArmDownUp;
FOUNDATION_EXPORT NSString *const kImageNameArmLeftRight;
FOUNDATION_EXPORT NSString *const kImageNameArmThrough;

// hand
FOUNDATION_EXPORT NSString *const kImageNameHand;
FOUNDATION_EXPORT NSString *const kImageNameHandThrough;

// switches
FOUNDATION_EXPORT NSString *const kImageNameSwitchYellowOff;
FOUNDATION_EXPORT NSString *const kImageNameSwitchYellowOn;
FOUNDATION_EXPORT NSString *const kImageNameSwitchRedOff;
FOUNDATION_EXPORT NSString *const kImageNameSwitchRedOn;

// door
FOUNDATION_EXPORT NSString *const kImageNameDoorYellow;
FOUNDATION_EXPORT NSString *const kImageNameDoorYellowOpen;
FOUNDATION_EXPORT NSString *const kImageNameDoorRed;
FOUNDATION_EXPORT NSString *const kImageNameDoorRedOpen;

// goal
FOUNDATION_EXPORT NSString *const kImageNameGoal;

+ (void)loadTextures;

@end
