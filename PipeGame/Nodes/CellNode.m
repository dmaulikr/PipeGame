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


- (id)init
{
    self = [super init];
    if (self) {
        _shouldSendPGTouchNotifications = NO;
    }
    return self;
}

- (GridCoord)cell
{
    return [GridUtils gridCoordForAbsolutePosition:self.position unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
}

- (BOOL)shouldBlockMovement
{
    return NO;
}


#pragma mark - pipe layers

- (void)setPipeLayersWithLayers:(NSNumber *)layer, ...
{
    _pipeLayers = [NSMutableArray array];
    va_list args;
    va_start(args, layer);
    for (NSNumber *arg = layer; arg != nil; arg = va_arg(args, NSNumber *))
    {
        [_pipeLayers addObject:arg];
    }
    va_end(args);
}

- (BOOL)isAtPipeLayer:(NSNumber *)layer
{    
    NSUInteger result = [self.pipeLayers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [layer isEqualToNumber:obj];
    }];
    return (result != NSNotFound);
}

- (NSNumber *)firstPipeLayer
{
    return [self.pipeLayers objectAtIndex:0];
}

#pragma mark - setup / teardown

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
    if ([self containsTouch:touch] && self.shouldSendPGTouchNotifications) {
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
    if (CGRectContainsPoint(rect, touchPosition)) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
