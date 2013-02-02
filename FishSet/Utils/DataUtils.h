//
//  DataUtils.h
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "GridUtils.h"

@interface DataUtils : NSObject

// entry coordinate for puzzle
+ (GridCoord)puzzleEntryCoord:(NSUInteger)puzzleNumber;

// entry coordinate for puzzle
+ (GridCoord)puzzleSize:(NSUInteger)puzzleNumber;

// direction hand enters puzzle, value 'right' would mean it enters to the right coming from the left side of a cell
+ (kDirection)puzzleEntryDirection:(NSUInteger)puzzleNumber;


@end
