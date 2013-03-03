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

- (void)addObjectToLibrary:(CellNode *)object cell:(GridCoord)cell
{
    if ([object isKindOfClass:[CellNode class]]) {
        NSMutableArray *objects = [self objectsForCell:cell];
        if ([objects containsObject:object] == NO) {
            [objects addObject:object];
            [self.objectLibrary setObject:objects forKey:[self objectKeyForCell:cell]];
        }
    }
    else {
        NSLog(@"warning: cell object library only takes objects of type CellNode");
    }
}

- (void)removeObjectFromLibrary:(CellNode *)object cell:(GridCoord)cell
{
    if ([self libraryContainsObject:object atCell:cell]) {
        NSMutableArray *objects = [self objectsForCell:cell];
        [objects removeObject:object];
        [self.objectLibrary setObject:objects forKey:[self objectKeyForCell:cell]];
    }
    else {
        NSLog(@"warning: cell object library does not contain object: %@", object);
    }
}

- (NSMutableArray *)objectsForCell:(GridCoord)cell
{
    return [self.objectLibrary objectForKey:[self objectKeyForCell:cell]];
}

- (BOOL)libraryContainsObject:(CellNode *)object atCell:(GridCoord)cell
{
    if ([object isKindOfClass:[CellNode class]] == NO) {
        NSLog(@"warning: cell object library only contains objects of kind CellNode, kind given: %@", [object class]);
    }
    NSMutableArray *objects = [self objectsForCell:cell];
    return ([objects containsObject:object]);
}

- (id)firstNodeOfKind:(Class)class atCell:(GridCoord)cell
{
    NSMutableArray *nodes = [self objectsForCell:cell];
    for (id node in nodes) {
        if ([node isKindOfClass:class]) {
            return node;
        }
    }
    NSLog(@"warning, node of kind: %@, not found at cell %i, %i", class, cell.x, cell.y);
    return nil;
}

@end
