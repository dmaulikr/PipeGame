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

-(id )initWithGridSize:(GridCoord)size;

- (void)addNodeToLibrary:(CellNode *)node cell:(GridCoord)cell;
- (void)removeNodeFromLibrary:(CellNode *)node cell:(GridCoord)cell;

- (NSMutableArray *)nodesForCell:(GridCoord)cell;
- (NSMutableArray *)nodesForCell:(GridCoord)cell layer:(int)layer;
- (BOOL)libraryContainsNode:(CellNode *)node atCell:(GridCoord)cell;
- (BOOL)libraryContainsNodestOfKind:(Class)class layer:(int)layer atCell:(GridCoord)cell;
- (NSMutableArray *)nodesOfKind:(Class)class atCell:(GridCoord)cell;
- (id)firstNodeOfKind:(Class)class atCell:(GridCoord)cell;
- (id)firstNodeOfKind:(Class)class atCell:(GridCoord)cell layer:(int)layer;


@end
