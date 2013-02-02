//
//  SpriteUtils.h
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@class CCSprite;

@interface SpriteUtils : NSObject

+ (float)degreesForDirection:(kDirection)direction;
+ (void)switchImageForSprite:(CCSprite *)sprite textureKey:(NSString *)key;
+ (CCSprite *)spriteWithTextureKey:(NSString *)key;

@end
