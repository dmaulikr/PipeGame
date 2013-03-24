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

-(id) initInCell:(GridCoord)cell layer:(int)layer
{
    self = [super init];
    if (self) {
        self.layer = layer;
        
        // position
        self.position = [GridUtils absolutePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
        
        // setup for sending notifications
        self.shouldSendPGTouchNotifications = YES;
        self.pgTouchNotification = kPGNotificationArmNodeTouched;
    }
    return self;
}

-(id) initInCell:(GridCoord)cell firstExit:(kDirection)firstExit secondExit:(kDirection)secondExit layer:(int)layer
{
    self = [self initInCell:cell layer:layer];
    if (self) {
        // add exits
        self.exits = [NSMutableArray array];
        [self.exits addObjectsFromArray:@[[ArmNode exitForDirection:firstExit], [ArmNode exitForDirection:secondExit]]];
        
        kArmExits exits = [self armExitsTypeForFirstExit:firstExit secondExit:secondExit];
        NSString *textureKey = [self textureKeyForArmExits:exits];
        self.sprite = [SpriteUtils spriteWithTextureKey:textureKey];
        [self positionAndAddSprite];
    }
    return self;
}

-(id) initForLayerConnectionInCell:(GridCoord)cell exit:(kDirection)exit layer:(int)layer
{
    self = [self initInCell:cell layer:layer];
    if (self) {
        // add exits
        self.exits = [NSMutableArray array];
        [self.exits addObjectsFromArray:@[[ArmNode exitForDirection:exit], [ArmNode exitForDirection:kDirectionThrough]]];
        
        self.sprite = [SpriteUtils spriteWithTextureKey:kImageNameArmThrough];
        self.sprite.rotation = [SpriteUtils degreesForDirection:exit];
        [self positionAndAddSprite];
    }
    return self;
}

-(void) positionAndAddSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:self.sprite];
}

-(BOOL) shouldBlockMovement
{
    return YES;
}

#pragma mark - image key

-(NSString *) imageForExits:(NSArray *)exits
{
    BOOL up;
    BOOL down;
    BOOL left;
    BOOL right;
    BOOL through;
    for (NSString *exit in exits) {
        up =[exit isEqualToString:@"up"];
        down = [exit isEqualToString:@"down"];
        left = [exit isEqualToString:@"left"];
        right = [exit isEqualToString:@"right"];
        through = [exit isEqualToString:@"through"];
    }
    if (up && down) {
        return kImageNameArmDownUp;
    }
    if (left && right) {
        return kImageNameArmLeftRight;
    }
    if (up && right) {
        return kImageNameArmUpRight;
    }
    if (up && left) {   
        return kImageNameArmUpLeft;
    }
    if (down && right) {
        return kImageNameArmDownRight;
    }
    if (down && left) {
        return kImageNameArmDownLeft;
    }
    // currently being rotated outside of this method, might be better to do it here
    if (through) {
        return kImageNameArmThrough;
    }
    else {
        NSLog(@"warning: no matching image type for exits: %@", exits);
        return nil;
    }
}

-(NSString *) textureKeyForArmExits:(kArmExits)exits
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


#pragma mark - exits

-(BOOL) isAtConnection
{
    for (NSString *exit in self.exits) {
        if ([exit isEqualToString:@"through"]) {
            return YES;
        }
    }
    return NO;
}

+(NSString *) exitForDirection:(kDirection)direction
{
    switch (direction) {
        case kDirectionUp:
            return @"up";
        case kDirectionDown:
            return @"down";
        case kDirectionLeft:
            return @"left";
        case kDirectionRight:
            return @"right";
        case kDirectionThrough:
            return @"through";
        default:
            NSLog(@"warning: invalid direction provided");
            return nil;
    }
}


@end
