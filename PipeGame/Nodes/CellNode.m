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
#import "CellObjectLibrary.h"


@implementation CellNode

-(id) init
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
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

-(void) moveTo:(GridCoord)cell puzzleOrigin:(CGPoint)origin
{
    GridCoord moveFrom = self.cell;
    self.cell = cell;
    self.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
    [self.transferResponder transferNode:self toCell:cell fromCell:moveFrom];
}


#pragma mark - scene management

- (void)onEnter
{
    if ([self needsTouchDelegate]) {        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    }
	[super onEnter];
}

- (void)onExit
{
    if ([self needsTouchDelegate]) {
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
	[super onExit];
}


#pragma mark - standard touch delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ((self.pgNotificationTouchBegan != nil) && [self containsTouch:touch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.pgNotificationTouchBegan object:self];
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ((self.pgNotificationTouchMoved != nil) && [self containsTouch:touch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.pgNotificationTouchMoved object:self];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ((self.pgNotificationTouchEnded != nil) && [self containsTouch:touch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.pgNotificationTouchEnded object:self];
    }
}

#pragma mark - touch utils

- (BOOL)needsTouchDelegate
{
    return ((self.pgNotificationTouchBegan != nil) || (self.pgNotificationTouchEnded != nil) || (self.pgNotificationTouchMoved != nil));
}

- (BOOL)containsTouch:(UITouch *)touch
{
    // instead of bounding box we must use custom rect w/ origin (0, 0) because the touch is relative to our node origin
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    return (CGRectContainsPoint(rect, touchPosition));
}

@end
