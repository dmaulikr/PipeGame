//
//  CellObjectLibrary.h
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"

@interface CellObjectLibrary : NSObject

@property (nonatomic, strong) NSMutableDictionary *objectLibrary;

- (id)initWithGridSize:(GridCoord)size;
- (void)addObjectToLibrary:(id)object cell:(GridCoord)cell;
- (void)removeObjectFromLibrary:(id)object cell:(GridCoord)cell;
- (NSMutableArray *)objectsForCell:(GridCoord)cell;

@end
