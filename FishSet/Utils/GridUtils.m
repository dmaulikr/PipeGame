//
//  GridUtils.m
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "GridUtils.h"

@implementation GridUtils

// absolute position on a grid for grid coordinate, bottom left
+ (CGPoint) absolutePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize origin:(CGPoint)origin
{
    CGFloat x = (coord.x * unitSize) + origin.x;
    CGFloat y = (coord.y * unitSize) + origin.y;
    return CGPointMake(x, y);
}

// grid coordinate for absolute position on a grid
+ (GridCoord) gridCoordForAbsolutePosition:(CGPoint)position unitSize:(CGFloat)unitSize origin:(CGPoint)origin;
{
    NSInteger x = floorf((position.x - origin.x) / unitSize);
    NSInteger y = floorf((position.y - origin.y) / unitSize);
    return GridCoordMake(x, y);
}

@end
