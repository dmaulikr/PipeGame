//
//  CellObjectLibrary.m
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import "CellObjectLibrary.h"

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

- (void)addObjectToLibrary:(id)object cell:(GridCoord)cell
{
    NSMutableArray *objects = [self objectListForCell:cell];
    if ([objects containsObject:object] == NO) {
        [objects addObject:object];
        [self.objectLibrary setObject:objects forKey:[self objectKeyForCell:cell]];
    }
}

- (void)removeObjectFromLibrary:(id)object cell:(GridCoord)cell
{
    NSMutableArray *objects = [self objectListForCell:cell];
    if ([objects containsObject:object]) {
        [objects removeObject:object];
        [self.objectLibrary setObject:objects forKey:[self objectKeyForCell:cell]];
    }
}

- (NSMutableArray *)objectListForCell:(GridCoord)cell
{
    return [self.objectLibrary objectForKey:[self objectKeyForCell:cell]];
}

@end
