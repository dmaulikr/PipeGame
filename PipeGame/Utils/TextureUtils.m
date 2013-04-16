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

// switches
NSString *const kImageNameSwitchYellowOff = @"switchOffYellow.png";
NSString *const kImageNameSwitchYellowOn = @"switchOnYellow.png";
NSString *const kImageNameSwitchRedOff = @"switchOffRed.png";
NSString *const kImageNameSwitchRedOn = @"switchOnRed.png";

// door
NSString *const kImageNameDoorYellow = @"doorYellow.png";
NSString *const kImageNameDoorYellowOpen = @"doorYellowOpen.png";
NSString *const kImageNameDoorRed = @"doorRed.png";
NSString *const kImageNameDoorRedOpen = @"doorRedOpen.png";

// goal
NSString *const kImageNameGoal = @"goal.png";

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
    
    // switches
    [[CCTextureCache sharedTextureCache] addImage:kImageNameSwitchYellowOff];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameSwitchYellowOn];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameSwitchRedOff];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameSwitchRedOn];
    
    // door
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorYellow];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorYellowOpen];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorRed];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameDoorRedOpen];
    
    // goal
    [[CCTextureCache sharedTextureCache] addImage:kImageNameGoal];

}

@end
