//
//  CellObjectLibrary.m
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import "CellObjectLibrary.h"
#import "CellNode.h"


@implementation CellObjectLibrary

- (id)initWithGridSize:(GridCoord)size
{
    self = [super init];
    if (self) {
        _objectLibrary = [NSMutableDictionary dictionary];
        for (int x = 1; x <= size.x; x++) {
            for (int y = 1; y <= size.y; y++) {
                [_objectLibrary setObject:[NSMutableArray array] forKey:[self objectKeyForCell:GridCoordMake(x, y)]];
            }
        }        
    }
    return self;
}

- (NSString *)objectKeyForCell:(GridCoord)cell
{
    return [NSString stringWithFormat:@"%i%i", cell.x, cell.y];
}


#pragma mark - add and remove objects

- (void)addNodeToLibrary:(CellNode *)node cell:(GridCoord)cell
{
    if ([node isKindOfClass:[CellNode class]]) {
        NSMutableArray *nodes = [self nodesForCell:cell];
        if ([nodes containsObject:node] == NO) {
            [nodes addObject:node];
            [self.objectLibrary setObject:nodes forKey:[self objectKeyForCell:cell]];
        }
    }
    else {
        NSLog(@"warning: cell object library only takes objects of type CellNode");
    }
}

- (void)removeNodeFromLibrary:(CellNode *)node cell:(GridCoord)cell
{
    if ([self libraryContainsNode:node atCell:cell]) {
        NSMutableArray *nodes = [self nodesForCell:cell];
        [nodes removeObject:node];
        [self.objectLibrary setObject:nodes forKey:[self objectKeyForCell:cell]];
    }
    else {
        NSLog(@"warning: cell object library does not contain object: %@", node);
    }
}


#pragma mark - library queries

- (NSMutableArray *)nodesForCell:(GridCoord)cell
{
    return [self.objectLibrary objectForKey:[self objectKeyForCell:cell]];
}

- (NSMutableArray *)nodesForCell:(GridCoord)cell atPipeLayer:(NSString *)pipeLayer
{
    NSMutableArray *nodes= [self nodesForCell:cell];
    NSMutableArray *nodesAtLayer = [NSMutableArray array];
    for (CellNode *node in nodes) {
        if ([node.firstPipeLayer isEqualToString:pipeLayer]) {
            [nodesAtLayer addObject:node];
        }
    }
    return nodesAtLayer;
}

- (BOOL)libraryContainsNode:(CellNode *)node atCell:(GridCoord)cell
{
    if ([node isKindOfClass:[CellNode class]] == NO) {
        NSLog(@"warning: cell object library only contains objects of kind CellNode, kind given: %@", [node class]);
    }
    NSMutableArray *nodes = [self nodesForCell:cell];
    return ([nodes containsObject:node]);
}

- (BOOL)libraryContainsNodesOfKind:(Class)class atCell:(GridCoord)cell
{
    NSMutableArray *results = [self nodesOfKind:class atCell:cell];
    return (results.count > 0);
}

- (BOOL)libraryContainsNodestOfKind:(Class)class atPipeLayer:(NSString *)pipeLayer atCell:(GridCoord)cell
{
    NSMutableArray *matchingKind = [self nodesOfKind:class atCell:cell];
    for (CellNode *node in matchingKind) {
        if ([node.firstPipeLayer isEqualToString:pipeLayer]) {
            return YES;
        }
    }
    return NO;
}


- (NSMutableArray *)nodesOfKind:(Class)class atCell:(GridCoord)cell
{
    NSMutableArray *nodes = [self nodesForCell:cell];
    NSMutableArray *results = [NSMutableArray array];
    for (id node in nodes) {
        if ([node isKindOfClass:class]) {
            [results addObject:node];
        }
    }
    return results;
}

- (NSMutableArray *)nodesOfKind:(Class)class atCell:(GridCoord)cell atPipeLayer:(NSString *)pipeLayer
{
    NSMutableArray *nodes = [self nodesOfKind:class atCell:cell];
    NSMutableArray *results = [NSMutableArray array];
    for (CellNode *node in nodes) {
        if ([node isAtPipeLayer:pipeLayer]) {
            [results addObject:node];
        }
    }
    return results;
}

- (id)firstNodeOfKind:(Class)class atCell:(GridCoord)cell
{
    NSMutableArray *nodes = [self nodesForCell:cell];
    for (id node in nodes) {
        if ([node isKindOfClass:class]) {
            return node;
        }
    }
    NSLog(@"warning, node of kind: %@, not found at cell %i, %i", class, cell.x, cell.y);
    return nil;
}

- (id)firstNodeOfKind:(Class)class atCell:(GridCoord)cell atPipeLayer:(NSString *)pipeLayer
{
    NSMutableArray *results = [self nodesOfKind:class atCell:cell];
    if (results.count > 0) {
        for (CellNode *r in results) {
            if ([r isAtPipeLayer:pipeLayer]) {
                return r;
            }
        }
    }
    NSLog(@"warning: node of kind: %@, with firstPipeLayer: %@, not found at cell %i, %i", class, pipeLayer, cell.x, cell.y);
    return nil;
}



@end
