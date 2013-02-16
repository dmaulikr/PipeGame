//
//  TextureUtils.h
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import <Foundation/Foundation.h>

@interface TextureUtils : NSObject


#pragma mark - image names

// arm
FOUNDATION_EXPORT NSString *const kImageNameArmDownLeft;
FOUNDATION_EXPORT NSString *const kImageNameArmDownRight;
FOUNDATION_EXPORT NSString *const kImageNameArmUpLeft;
FOUNDATION_EXPORT NSString *const kImageNameArmUpRight;
FOUNDATION_EXPORT NSString *const kImageNameArmDownUp;
FOUNDATION_EXPORT NSString *const kImageNameArmLeftRight;

// hand
FOUNDATION_EXPORT NSString *const kImageNameHand;


#pragma mark - methods

+ (void)loadTextures;

@end
