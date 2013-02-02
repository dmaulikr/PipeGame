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
                [_objectLibrary setObject:[NSNull null] forKey:[self objectKeyForCell:GridCoordMake(x, y)]];
            }
        }        
    }
    return self;
}

- (NSString *)objectKeyForCell:(GridCoord)cell
{
    return [NSString stringWithFormat:@"%i%i", cell.x, cell.y];
}


@end
