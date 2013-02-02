//
//  SpriteUtils.m
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "SpriteUtils.h"
#import "cocos2d.h"

@implementation SpriteUtils

+ (float)degreesForDirection:(kDirection)direction
{
    if (direction == kDirectionUp) {
        return 0.0f;
    }
    else if (direction == kDirectionRight) {
        return 90.0f;
    }
    else if (direction == kDirectionDown) {
        return 180.0f;
    }
    else if (direction == kDirectionLeft) {
        return  270.0f;
    }
    NSLog(@"warning: %i is an invalid direciton, returning 0.0f", direction);
    return 0.0f;
}

+ (void)switchImageForSprite:(CCSprite *)sprite textureKey:(NSString *)key
{
    [sprite setTexture:[[CCTextureCache sharedTextureCache] textureForKey:key]];
}

+ (CCSprite *)spriteWithTextureKey:(NSString *)key
{
    return [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:key]];
}


@end
