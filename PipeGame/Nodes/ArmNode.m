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

NSString *const kPGNotificationArmNodeTouched = @"ArmNodeTouched";

@implementation ArmNode

- (id)initInCell:(GridCoord)cell firstExit:(kDirection)firstExit secondExit:(kDirection)secondExit pipeLayer:(NSString *)pipeLayer
{
    self = [super init];
    if (self) {
        
        self.pipeLayers = @[pipeLayer];
        
        // size, position
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        self.position = [GridUtils absolutePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
        
        // setup for sending notifications
        self.shouldSendPGTouchNotifications = YES;
        self.pgTouchNotification = kPGNotificationArmNodeTouched;
        
        // setup sprite with correct image 
        kArmExits exits = [self armExitsTypeForFirstExit:firstExit secondExit:secondExit];
        NSString *textureKey = [self textureKeyForArmExits:exits];
        _sprite = [SpriteUtils spriteWithTextureKey:textureKey];
        _sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_sprite];
    }
    return self;
}

#pragma mark - CCNode+Utils

- (BOOL)shouldBlockMovement
{
    return YES;
}

#pragma mark - image key

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
