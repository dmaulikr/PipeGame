//
//  PipeNode.m
//  FishSet
//
//  Created by John Saba on 2/6/13.
//
//

#import "PipeNode.h"
#import "PuzzleLayer.h"



@implementation PipeNode

- (id)initInCell:(GridCoord)cell exits:(NSArray *)exits
{
    self = [super init];
    if (self) {
        
        // size, position
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        self.position = [GridUtils absolutePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
        
    }
    return self;
}

@end
