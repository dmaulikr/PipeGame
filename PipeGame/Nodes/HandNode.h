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
FOUNDATION_EXPORT NSString *const kPGNotificationHandNodeMoved;


@interface HandNode : CellNode 

@property (strong, nonatomic) CCSprite *connectionSprite;
@property (assign) kDirection facing;

-(void) setDirectionFacing:(kDirection)direction;

@end
