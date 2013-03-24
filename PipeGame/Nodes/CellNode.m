//
//  CellNode.m
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "CellNode.h"
#import "GameConstants.h"
#import "PuzzleLayer.h"
#import "SpriteUtils.h"
#import "PGTiledUtils.h"

@implementation CellNode


-(id) init
{
    self = [super init];
    if (self) {
        _shouldSendPGTouchNotifications = NO;
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

-(GridCoord) cell
{
    return [GridUtils gridCoordForAbsolutePosition:self.position unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
}

-(BOOL) shouldBlockMovement
{
    return NO;
}

-(NSString *) layerName
{
    return [PGTiledUtils layerName:self.layer];
}

-(CCSprite *) createAndCenterSpriteNamed:(NSString *)name
{
    CCSprite *sprite = [SpriteUtils spriteWithTextureKey:name];
    sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    return sprite;
}

#pragma mark - pipe layers

//- (BOOL)isAtPipeLayer:(NSString *)layer
//{
//    NSUInteger result = [self.pipeLayers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//        NSString *isAtLayer = (NSString *)obj;
//        return [layer isEqualToString:isAtLayer];
//    }];
//    return (result != NSNotFound);
//}

// use this if we only expect a cell node to belong to 1 layer at a time
//- (NSString *)firstPipeLayer
//{
//    return [self.pipeLayers objectAtIndex:0];
//}

#pragma mark - scene management

- (void)onEnter
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	[super onEnter];
}

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}


#pragma mark - targeted touch delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.shouldSendPGTouchNotifications && [self containsTouch:touch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.pgTouchNotification object:self];
        return YES;
    }
    return NO;
}


#pragma mark - touch utils

- (BOOL)containsTouch:(UITouch *)touch
{
    // instead of bounding box we must use custom rect w/ origin (0, 0) because the touch is relative to our node origin
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    return (CGRectContainsPoint(rect, touchPosition));
}


@end
