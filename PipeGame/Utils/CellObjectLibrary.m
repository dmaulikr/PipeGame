//
//  CellObjectLibrary.m
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import "CellObjectLibrary.h"
#import "CellNode.h"

NSString *const kPGNotificationCellNodeLibraryChangedContents = @"CellNodeLibraryChangedContents";


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


#pragma mark - add, remove, shift objects
// TODO: if each cell object is expected to have a cell, then we dont' need to pass in cell
- (void)addNode:(CellNode *)node cell:(GridCoord)cell
{
    if ([node isKindOfClass:[CellNode class]]) {
        NSMutableArray *nodes = [self nodesForCell:cell];
        if ([nodes containsObject:node] == NO) {
            [nodes addObject:node];
            [self.objectLibrary setObject:nodes forKey:[self objectKeyForCell:cell]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPGNotificationCellNodeLibraryChangedContents object:self];
        }
    }
    else {
        NSLog(@"warning: cell object library only takes objects of type CellNode");
    }
}

- (void)removeNode:(CellNode *)node cell:(GridCoord)cell
{
    if ([self containsNode:node cell:cell]) {
        NSMutableArray *nodes = [self nodesForCell:cell];
        [nodes removeObject:node];
        [self.objectLibrary setObject:nodes forKey:[self objectKeyForCell:cell]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPGNotificationCellNodeLibraryChangedContents object:self];
    }
    else {
        NSLog(@"warning: cell object library does not contain object: %@", node);
    }
}

-(void) transferNode:(CellNode *)node toCell:(GridCoord)moveTo fromCell:(GridCoord)moveFrom
{
    [self removeNode:node cell:moveFrom];
    [self addNode:node cell:moveTo];
}


#pragma mark - library queries

- (NSMutableArray *)nodesForCell:(GridCoord)cell
{
    return [self.objectLibrary objectForKey:[self objectKeyForCell:cell]];
}

- (NSMutableArray *)nodesForCell:(GridCoord)cell layer:(int)layer
{
    NSMutableArray *nodes= [self nodesForCell:cell];
    NSMutableArray *nodesAtLayer = [NSMutableArray array];
    for (CellNode *node in nodes) {
        if (node.layer == layer) {
            [nodesAtLayer addObject:node];
        }
    }
    return nodesAtLayer;
}

- (BOOL)containsNode:(CellNode *)node cell:(GridCoord)cell
{
    if ([node isKindOfClass:[CellNode class]] == NO) {
        NSLog(@"warning: cell object library only contains objects of kind CellNode, kind given: %@", [node class]);
    }
    NSMutableArray *nodes = [self nodesForCell:cell];
    return ([nodes containsObject:node]);
}

- (BOOL)containsNodeOfKind:(Class)class cell:(GridCoord)cell
{
    NSMutableArray *results = [self nodesOfKind:class atCell:cell];
    return (results.count > 0);
}

- (BOOL)containsNodeOfKind:(Class)class layer:(int)layer cell:(GridCoord)cell
{
    NSMutableArray *matchingKind = [self nodesOfKind:class atCell:cell];
    for (CellNode *node in matchingKind) {
        if (node.layer == layer) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsAnyNodeOfKinds:(NSArray *)kinds layer:(int)layer cell:(GridCoord)cell
{
    for (Class class in kinds) {
        if ([self containsNodeOfKind:class layer:layer cell:cell]) {
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

- (NSMutableArray *)nodesOfKind:(Class)class atCell:(GridCoord)cell layer:(int)layer
{
    NSMutableArray *nodes = [self nodesOfKind:class atCell:cell];
    NSMutableArray *results = [NSMutableArray array];
    for (CellNode *node in nodes) {
        if (node.layer == layer) {
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

- (id)firstNodeOfKind:(Class)class atCell:(GridCoord)cell layer:(int)layer
{
    NSMutableArray *results = [self nodesOfKind:class atCell:cell];
    if (results.count > 0) {
        for (CellNode *r in results) {
            if (r.layer == layer) {
                return r;
            }
        }
    }
    NSLog(@"warning: node of kind: %@, with firstPipeLayer: %i, not found at cell %i, %i", class, layer, cell.x, cell.y);
    return nil;
}

@end
