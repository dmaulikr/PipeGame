//
//  ArmNode.m
//  FishSet
//
//  Created by John Saba on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ArmNode.h"
#import "TextureUtils.h"
#import "GameConstants.h"
#import "SpriteUtils.h"
#import "PuzzleLayer.h"

@implementation ArmNode

- (id)initInCell:(GridCoord)cell firstExit:(kDirection)firstExit secondExit:(kDirection)secondExit
{
    self = [super init];
    if (self) {
        
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        
        kArmExits exits = [self armExitsTypeForFirstExit:firstExit secondExit:secondExit];
        NSString *textureKey = [self textureKeyForArmExits:exits];
        
        _sprite = [SpriteUtils spriteWithTextureKey:textureKey];
        _sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_sprite];
        
        self.position = [GridUtils absolutePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
    }
    return self;
}

- (NSString *)textureKeyForArmExits:(kArmExits)exits
{
    switch (exits) {
        case kArmExitsDownLeft:
            return kImageNameArmDownLeft;
        case kArmExitsDownRight:
            return kImageNameArmDownRight;
        case kArmExitsUpLeft:
            return kImageNameArmUpLeft;
        case kArmExitsUpRight:
            return kImageNameArmUpRight;
        case kArmExitsDownUp:
            return kImageNameArmDownUp;
        case kArmExitsLeftRight:
            return kImageNameArmLeftRight;
        default:
            NSLog(@"warning: unknown arm exit type, returning nil");
            return nil;
    }
}

- (kArmExits)armExitsTypeForFirstExit:(kDirection)firstExit secondExit:(kDirection)secondExit
{
    if (firstExit == kDirectionDown) {
        if (secondExit == kDirectionUp) {
            return kArmExitsDownUp;
        }
        else if (secondExit == kDirectionLeft) {
            return kArmExitsDownLeft;
        }
        else if (secondExit == kDirectionRight) {
            return kArmExitsDownRight;
        }
    }
    else if (firstExit == kDirectionUp) {
        if (secondExit == kDirectionDown) {
            return kArmExitsDownUp;
        }
        else if (secondExit == kDirectionLeft) {
            return kArmExitsUpLeft;
        }
        else if (secondExit == kDirectionRight) {
            return kArmExitsUpRight;
        }
    }
    else if (firstExit == kDirectionRight) {
        if (secondExit == kDirectionLeft) {
            return kArmExitsLeftRight;
        }
        else if (secondExit == kDirectionDown) {
            return kArmExitsDownRight;
        }
        else if (secondExit == kDirectionUp) {
            return kArmExitsUpRight;
        }
    }
    else if (firstExit == kDirectionLeft) {
        if (secondExit == kDirectionRight) {
            return kArmExitsLeftRight;
        }
        else if (secondExit == kDirectionDown) {
            return kArmExitsDownLeft;
        }
        else if (secondExit == kDirectionUp) {
            return kArmExitsUpLeft;
        }
    }
    
    NSLog(@"warning: invalid set of exits given, returning kArmExitsNone");
    return kArmExitsNone;
}



@end
