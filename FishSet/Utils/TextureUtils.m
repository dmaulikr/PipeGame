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


#pragma mark - image names

// arm 
NSString *const kImageNameArmDownLeft = @"arm_corner_SW.png";
NSString *const kImageNameArmDownRight = @"arm_corner_SE.png";
NSString *const kImageNameArmUpLeft = @"arm_corner_NW.png";
NSString *const kImageNameArmUpRight = @"arm_corner_NE.png";
NSString *const kImageNameArmBottomTop = @"arm_straight_vertical.png";
NSString *const kImageNameArmLeftRight = @"arm_straight_horizontal.png";

// hand
NSString *const kImageNameHand = @"arm_hand_N.png";


#pragma mark - methods

+ (void)loadTextures
{
    // arm 
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmDownLeft];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmDownRight];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmUpLeft];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmUpRight];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmBottomTop];
    [[CCTextureCache sharedTextureCache] addImage:kImageNameArmLeftRight];
    
    // hand
    [[CCTextureCache sharedTextureCache] addImage:kImageNameHand];

}

@end
