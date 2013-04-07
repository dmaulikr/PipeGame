//
//  HandController.m
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "HandNode.h"

#import "SpriteUtils.h"
#import "GridUtils.h"
#import "GameConstants.h"
#import "PuzzleLayer.h"
#import "TextureUtils.h"
#import "ArmNode.h"

NSString *const kPGNotificationHandNodeTouched = @"HandNodeTouched";
NSString *const kPGNotificationHandNodeMoved = @"HandNodeMoved";


@implementation HandNode

-(id) init
{
    self = [super init];
    if (self) {
        // add sprites
        self.sprite = [self createAndCenterSpriteNamed:kImageNameHand];
        [self addChild:self.sprite];
        
        _connectionSprite = [self createAndCenterSpriteNamed:kImageNameHandThrough];
        _connectionSprite.visible = NO;
        [self addChild:_connectionSprite];
        
        // setup for sending notifications
        self.pgNotificationTouchBegan = kPGNotificationHandNodeTouched;
        
        _facing = kDirectionNone;
        
        [self registerNotifications];
    }
    return self;
}

-(void) registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleArmStackChanged:) name:kPGNotificationArmStackChanged object:nil];
}

-(void) onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

-(void) moveTo:(GridCoord)cell puzzleOrigin:(CGPoint)origin
{
    [super moveTo:cell puzzleOrigin:origin];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPGNotificationHandNodeMoved object:self];
}

-(void) setDirectionFacing:(kDirection)direction
{
    self.sprite.rotation = [SpriteUtils degreesForDirection:direction];
    self.connectionSprite.rotation = [SpriteUtils degreesForDirection:direction];
    self.facing = direction;
}

-(void) setAtConnection:(BOOL)atConnection
{
    self.sprite.visible = !atConnection;
    self.connectionSprite.visible = atConnection;
}

-(void) handleArmStackChanged:(NSNotification *)notification
{
    NSMutableArray *armStack = (NSMutableArray *)notification.object;
    
    if (armStack.count > 0) {
        ArmNode *lastArmNode = [armStack lastObject];
        BOOL isEmerging = !(lastArmNode.layer == self.layer);
        [self setAtConnection:isEmerging];
    }
}

@end
