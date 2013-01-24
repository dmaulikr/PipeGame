//
//  GridUtils.m
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "GridUtils.h"

#import "CCDrawingPrimitives.h"

@implementation GridUtils
{
    
}

#pragma mark - coord to position conversions

// absolute position on a grid for grid coordinate, bottom left
+ (CGPoint) absolutePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize origin:(CGPoint)origin
{
    CGFloat x = ((coord.x - 1) * unitSize) + origin.x;
    CGFloat y = ((coord.y - 1) * unitSize) + origin.y;
    return CGPointMake(x, y);
}

// grid coordinate for absolute position on a grid
+ (GridCoord) gridCoordForAbsolutePosition:(CGPoint)position unitSize:(CGFloat)unitSize origin:(CGPoint)origin;
{
    NSInteger x = floorf((position.x - origin.x) / unitSize) + 1;
    NSInteger y = floorf((position.y - origin.y) / unitSize) + 1;
    return GridCoordMake(x, y);
}

#pragma mark - drawing

// draws grid lines, call in layer's draw method
+ (void)drawGridWithSize:(GridCoord)gridSize unitSize:(CGFloat)unitSize origin:(CGPoint)origin
{
    CGSize windowSize = CGSizeMake(gridSize.x * unitSize, gridSize.y * unitSize);
    
    for (int i=0; i <= gridSize.x; i++) {
        CGPoint relStart = CGPointMake((i * windowSize.width) / gridSize.x, 0);
        CGPoint relEnd = CGPointMake((i * windowSize.width) / gridSize.x, windowSize.height);
        
        CGPoint start = CGPointMake(relStart.x + origin.x, relStart.y + origin.y);
        CGPoint end = CGPointMake(relEnd.x + origin.x, relEnd.y + origin.y);
        
        ccDrawLine(start, end);
    }
    for (int i=0; i <= gridSize.y; i++) {
        CGPoint relStart = CGPointMake(0, (i * windowSize.height) / gridSize.y);
        CGPoint relEnd = CGPointMake(windowSize.width, (i * windowSize.height) / gridSize.y);
        
        CGPoint start = CGPointMake(relStart.x + origin.x, relStart.y + origin.y);
        CGPoint end = CGPointMake(relEnd.x + origin.x, relEnd.y + origin.y);
        
        ccDrawLine(start, end);
    }
}

#pragma mark - compare 

// number of cell steps to get from starting coord to ending coord, no diagonal path allowed
+ (int)numberOfStepsBetweenStart:(GridCoord)start end:(GridCoord)end
{
    // stepping along y
    if (start.x == end.x) {
        return abs(start.y - end.y);
    }
    // stepping along x
    else if (start.y == end.y) {
        return abs(start.x - end.x);
    }
    // non-linear movement not allowed.
    else {
        return 0;
    }
}

// direction by comparing starting coord and ending coord, no diagonal path allowed
+ (kDirection)directionFromStart:(GridCoord)start end:(GridCoord)end
{
    // y movement
    if (start.x == end.x) {
        if (start.y > end.y) {
            return kDirectionDown;
        }
        else if (start.y < end.y) {
            return kDirectionUp;
        }
    }
    // x movement
    else if (start.y == end.y) {
        if (start.x > end.x) {
            return kDirectionLeft;
        }
        else if (start.x < end.x) {
            return kDirectionRight;
        }
    }
    
    // if none of above cases are true, move is invalid
    return kDirectionNone;
}








@end
