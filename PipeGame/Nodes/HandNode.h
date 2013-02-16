//
//  HandController.h
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "CellNode.h"
#import "GridUtils.h"

FOUNDATION_EXPORT NSString *const kPGNotificationHandNodeTouched;


@interface HandNode : CellNode

@property (nonatomic, strong) CCSprite *sprite;
@property (assign) kDirection facing;

- (id)initWithContentSize:(CGSize)size;
- (void)setDirectionFacing:(kDirection)direction;

@end
