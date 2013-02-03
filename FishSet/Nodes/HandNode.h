//
//  HandController.h
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "CellNode.h"
#import "GridUtils.h"

@interface HandNode : CellNode

@property (nonatomic, strong) CCSprite *handSprite;
@property (assign) kDirection facing;

- (id)initWithContentSize:(CGSize)size;
- (void)setDirectionFacing:(kDirection)direction;

@end
