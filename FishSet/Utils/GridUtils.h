//
//  GridUtils.h
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import <Foundation/Foundation.h>

typedef struct
{
    int x;
    int y;
    
} GridCoord;

// helper function to create a GridCoord
static inline GridCoord
GridCoordMake(const int x, const int y)
{
	GridCoord gridCoord = {x, y};
	return gridCoord;
}


@interface GridUtils : NSObject

// absolute center position on a grid for grid coordinate
+ (CGPoint) absolutePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

// grid coordinate for absolute position on a grid (any position inside a grid unit)
+ (GridCoord) gridCoordForAbsolutePosition:(CGPoint)position unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

// draws grid lines, call in layer's draw method
+ (void)drawGridWithSize:(GridCoord)gridSize unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

@end
