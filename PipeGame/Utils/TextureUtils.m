//
//  TextureUtils.m
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import "TextureUtils.h"
#import "cocos2d.h"

@implementation TextureUtils

// arm 
NSString *const kImageNameArmDownLeft = @"arm_corner_SW.png";
NSString *const kImageNameArmDownRight = @"arm_corner_SE.png";
NSString *const kImageNameArmUpLeft = @"arm_corner_NW.png";
NSString *const kImageNameArmUpRight = @"arm_corner_NE.png";
NSString *const kImageNameArmDownUp = @"arm_straight_vertical.png";
NSString *const kImageNameArmLeftRight = @"arm_straight_horizontal.png";
NSString *const kImageNameArmThrough = @"arm_through.png";

// hand
NSString *const kImageNameHand = @"arm_hand_S.png";
NSString *const kImageNameHandThrough = @"hand_through.png";

// rat
NSString *const kImageNameRatPurple = @"ratPurple.png";
NSString *const kImageNameRatRed = @"ratRed.png";

// door
NSString *const kImageNameDoorPurple = @"doorPurple.png";
NSString *const kImageNameDoorPurpleOpen = @"doorPurpleOpen.png";
NSString *const kImageNameDoorRed = @"doorRed.png";
NSString *const kImageNameDoorRedOpen = @"doorRedOpen.png";

+ (void)loadTextures
{
    // arm 
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmDownLeft];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmDownRight];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmUpLeft];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmUpRight];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmDownUp];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmLeftRight];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmThrough];
    
    // hand
    [[CCTextureCache sharedTextureCache] addImage:kImageNameHand];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameHandThrough];
    
    // rat
    [[CCTextureCache sharedTextureCache] addImage:kImageNameRatPurple];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameRatRed];
    
    // door
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorPurple];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorPurpleOpen];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorRed];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorRedOpen];
}

@end
