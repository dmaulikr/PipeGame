//
//  HandController.h
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "cocos2d.h"
#import "GameTypes.h"
#import "GridUtils.h"
#import "CCNode+Utils.h"

@interface HandNode : CCNode 

@property (nonatomic, strong) CCSprite *handSprite;
@property (assign) kDirection facing;
@property (assign) kDirection lastFacing;
@property (assign) GridCoord moveFromCell;
@property (assign) GridCoord moveToCell;

- (id)initWithContentSize:(CGSize)size;
- (void)setDirectionFacing:(kDirection)direction;

@end
