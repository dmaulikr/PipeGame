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

@implementation CellNode

- (GridCoord)cell
{
    return [GridUtils gridCoordForAbsolutePosition:self.position unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
}

// implementing class should overwrite to return YES if they want to block arm movement
- (BOOL)shouldBlockMovement
{
    return NO;
}

#pragma mark - targeted touch delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouch:touch]) {
        
        return YES;
    }
    return NO;
}

- (void)onEnter
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    if (CGRectContainsPoint(rect, touchPosition)) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
