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

@property (assign) BOOL shouldSendPGTouchNotifications;
@property (copy) NSString *pgTouchNotification;

@property (strong, nonatomic) CCSprite *sprite;

@property (assign) int layer;

// returns sprite with image name, centered in content bounds
-(CCSprite *) createAndCenterSpriteNamed:(NSString *)name;

-(GridCoord) cell;

-(BOOL) shouldBlockMovement;

-(NSString *) layerName;

@end
