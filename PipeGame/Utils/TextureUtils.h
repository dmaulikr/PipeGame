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

// rats
FOUNDATION_EXPORT NSString *const kImageNameRatPurple;
FOUNDATION_EXPORT NSString *const kImageNameRatRed;

// door
FOUNDATION_EXPORT NSString *const kImageNameDoorPurple;
FOUNDATION_EXPORT NSString *const kImageNameDoorPurpleOpen;
FOUNDATION_EXPORT NSString *const kImageNameDoorRed;
FOUNDATION_EXPORT NSString *const kImageNameDoorRedOpen;

+ (void)loadTextures;

@end
