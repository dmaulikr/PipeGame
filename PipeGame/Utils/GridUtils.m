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


#pragma mark - conversions

// absolute position on a grid for grid coordinate, bottom left
+ (CGPoint)absolutePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize origin:(CGPoint)origin
{
    CGFloat x = ((coord.x - 1) * unitSize) + origin.x;
    CGFloat y = ((coord.y - 1) * unitSize) + origin.y;
    return CGPointMake(x, y);
}

// grid coordinate for absolute position on a grid
+ (GridCoord)gridCoordForAbsolutePosition:(CGPoint)position unitSize:(CGFloat)unitSize origin:(CGPoint)origin;
{
    int x = floorf((position.x - origin.x) / unitSize) + 1;
    int y = floorf((position.y - origin.y) / unitSize) + 1;
    return GridCoordMake(x, y);
}

// absolute position made for sprite (anchor point middle) on a grid for grid coordinate
+ (CGPoint)absoluteSpritePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize origin:(CGPoint)origin
{
    CGFloat x = ((coord.x - 1) * unitSize) + origin.x;
    CGFloat y = ((coord.y - 1) * unitSize) + origin.y;
    return CGPointMake(x + unitSize/2, y + unitSize/2);
}

# pragma mark - tiled map editor 

// translate position to tiled grid coordinate, with origin in top left and 0 based indexing
+ (GridCoord)tiledGridCoordForPosition:(CGPoint)position tileMap:(CCTMXTiledMap *)tileMap origin:(CGPoint)origin
{
    if (tileMap.tileSize.width != tileMap.tileSize.height) {
        NSLog(@"warning: tileMap tileSize is not square");
    }
    GridCoord coord = [GridUtils gridCoordForAbsolutePosition:position unitSize:(tileMap.tileSize.width / 2) origin:origin];
    return GridCoordMake(coord.x - 1, tileMap.mapSize.height - coord.y);
}

// cocos2d tiled extension objects take coords in CGPoint form
+ (CGPoint)tiledCoordForPosition:(CGPoint)position tileMap:(CCTMXTiledMap *)tileMap origin:(CGPoint)origin
{
    GridCoord coord = [GridUtils tiledGridCoordForPosition:position tileMap:tileMap origin:origin];
    return CGPointMake(coord.x, coord.y);
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


#pragma mark - distance

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


#pragma mark - directions

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
    
    return kDirectionNone;
}

+ (kDirection)oppositeDirection:(kDirection)direction
{
    switch (direction) {
        case kDirectionDown:
            return kDirectionUp;
        case kDirectionUp:
            return kDirectionDown;
        case kDirectionLeft:
            return kDirectionRight;
        case kDirectionRight:
            return kDirectionLeft;
        default:
            NSLog(@"warning: invalid direction given, returning kDirectionNone");
            return kDirectionNone;
    }
}

+ (GridCoord)stepInDirection:(kDirection)direction fromCell:(GridCoord)cell
{
    if (direction == kDirectionUp) {
        return GridCoordMake(cell.x, cell.y + 1);
    }
    else if (direction == kDirectionRight) {
        return GridCoordMake(cell.x + 1, cell.y);
    }
    else if (direction == kDirectionDown) {
        return GridCoordMake(cell.x, cell.y - 1);
    }
    else if (direction == kDirectionLeft) {
        return GridCoordMake(cell.x - 1, cell.y);
    }
    else {
        NSLog(@"warning: unrecognized direction");
        return cell;
    }
}


#pragma mark - compare

// checks for gridcoords as same coordinate
+ (BOOL)isCell:(GridCoord)firstCell equalToCell:(GridCoord)secondCell
{
    return ((firstCell.x == secondCell.x) && (firstCell.y == secondCell.y));
}

+ (BOOL)isCellInBounds:(GridCoord)cell gridSize:(GridCoord)size
{
    return (cell.x > 0 && cell.x <= size.x && cell.y > 0 && cell.y <= size.y);
}

#pragma mark - perform

// iterate between a path strictly up/down or left/right performing block with cell
+ (void)performBlockBetweenFirstCell:(GridCoord)firstCell
                          secondCell:(GridCoord)secondCell
                               block:(void (^)(GridCoord cell, kDirection direction))block
{
    kDirection movingDirection = [GridUtils directionFromStart:firstCell end:secondCell];
    if (movingDirection == kDirectionUp) {
        for (int y = firstCell.y; y <= secondCell.y; y++) {
            GridCoord cell = GridCoordMake(firstCell.x, y);
            block(cell, movingDirection);
        }
    }
    else if (movingDirection == kDirectionRight) {
        for (int x = firstCell.x; x <= secondCell.x; x++) {
            GridCoord cell = GridCoordMake(x, firstCell.y);
            block(cell, movingDirection);
        }
    }
    else if (movingDirection == kDirectionDown) {
        for (int y = firstCell.y; y >= secondCell.y; y--) {

            GridCoord cell = GridCoordMake(firstCell.x, y);
            block(cell, movingDirection);
        }
    }
    else if (movingDirection == kDirectionLeft) {
        for (int x = firstCell.x; x >= secondCell.x; x--) {
            GridCoord cell = GridCoordMake(x, firstCell.y);
            block(cell, movingDirection);
        }
    } 
}



@end