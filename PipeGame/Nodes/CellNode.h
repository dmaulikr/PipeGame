//
//  CellNode.h
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"

@class CellNode;

@protocol TransferResponder <NSObject>

// to pass along cell-change information to who ever owns the cell node library
-(void) transferNode:(CellNode *)node toCell:(GridCoord)moveTo fromCell:(GridCoord)moveFrom;

@end


@interface CellNode : CCNode <CCTargetedTouchDelegate>

@property (copy, nonatomic) NSString *pgNotificationTouchBegan;
@property (copy, nonatomic) NSString *pgNotificationTouchMoved;
@property (copy, nonatomic) NSString *pgNotificationTouchEnded;

@property (strong, nonatomic) CCSprite *sprite;
@property (assign) int layer;
@property (assign) GridCoord cell;

@property (weak, nonatomic) id<TransferResponder>transferResponder;

-(CCSprite *) createAndCenterSpriteNamed:(NSString *)name; // returns sprite with image name, centered in content bounds
-(void) moveTo:(GridCoord)cell puzzleOrigin:(CGPoint)origin;
- (BOOL)shouldBlockMovement;
- (NSString *)layerName;

@end
