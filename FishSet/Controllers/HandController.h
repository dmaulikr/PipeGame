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

@interface HandController : CCNode

@property (nonatomic, strong) CCSprite *handSprite;
@property (assign) kDirection facing;
@property (assign) int cellsPerSecond;
@property (assign) GridCoord moveTo;


- (id)initWithContentSize:(CGSize)size;
- (void)setDirectionFacing:(kDirection)direction;
- (void)rotateToFacing:(kDirection)direction withCompletion:(CCCallFunc *)completion;


@end
