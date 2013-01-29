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
@property (assign) BOOL isMoving;

@property (readonly) GridCoord cell;
@property (assign) GridCoord moveFromCell;
@property (assign) GridCoord moveToCell;


- (id)initWithContentSize:(CGSize)size;
- (void)setDirectionFacing:(kDirection)direction;
- (void)rotateToFacing:(kDirection)direction withCompletion:(CCCallFunc *)completion;
- (void)moveFromStart:(GridCoord)start toEnd:(GridCoord)end;
- (void)movePath;


@end
