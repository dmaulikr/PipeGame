//
//  CellNode.h
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"


@interface CellNode : CCNode <CCTargetedTouchDelegate>

@property (assign) BOOL shouldSendPGTouchNotifications;
@property (copy) NSString *pgTouchNotification;
@property (strong, nonatomic) NSArray *pipeLayers;
@property (strong, nonatomic) CCSprite *sprite;

// returns sprite with image name, centered in content bounds
-(CCSprite *) createAndCenterSpriteNamed:(NSString *)name;

-(GridCoord) cell;
-(BOOL) shouldBlockMovement;
-(BOOL) isAtPipeLayer:(NSString *)pipeLayer;
-(NSString *) firstPipeLayer;

@end
