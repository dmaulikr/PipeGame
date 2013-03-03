//
//  CellObjectLibrary.h
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"
@class CellNode;

@interface CellObjectLibrary : NSObject

@property (nonatomic, strong) NSMutableDictionary *objectLibrary;

- (id)initWithGridSize:(GridCoord)size;
- (void)addObjectToLibrary:(CellNode *)object cell:(GridCoord)cell;
- (void)removeObjectFromLibrary:(CellNode *)object cell:(GridCoord)cell;
- (NSMutableArray *)objectsForCell:(GridCoord)cell;
- (BOOL)libraryContainsObject:(CellNode *)object atCell:(GridCoord)cell;
- (id)firstNodeOfKind:(Class)class atCell:(GridCoord)cell;

@end
