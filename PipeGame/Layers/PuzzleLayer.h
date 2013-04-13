//
//  PuzzleLayer.h
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"
#import "HandNode.h"
#import "CoverPoint.h"
@class ArmController;
@class CellObjectLibrary;
@class PGEntry;
@class BackgroundLayer;

typedef enum
{
    kLayerBackground = 0,
    kLayerPipe1,
    kLayerUnder1,
    kLayerHand1,
    kLayerOver1,
    kLayerPipe2,
    kLayerUnder2,
    kLayerHand2,
    kLayerOver2,
    kLayerHud
} kLayer;

FOUNDATION_EXPORT NSString *const kPGNotificationArmStackChanged;


@interface PuzzleLayer : CCLayerColor <TransferResponder, CoverPointDelegate>

// background
@property (nonatomic, strong) BackgroundLayer *backgroundLayer;

// pipe layers
@property (nonatomic, strong) CCLayerColor *layer1;
@property (nonatomic, strong) CCLayerColor *layer2;

// grid
@property (assign) GridCoord gridSize;

// tilemap
@property (nonatomic, strong) CCTMXTiledMap *tileMap;
@property (nonatomic, strong) NSArray *tiledLayers;

// tiled objects
@property (nonatomic, strong) PGEntry *entry;

// list of game objects at each cell
@property (nonatomic, strong) CellObjectLibrary *cellObjectLibrary;

// hand and arm 
@property (nonatomic, strong) HandNode *handNode;
@property (nonatomic, strong) NSMutableArray *armNodes;
@property (assign) kDirection handEntersFrom;
@property (assign) BOOL isHandNodeSelected;

// rats (cover points)
@property (nonatomic, strong) NSMutableArray *rats;

// doors
@property (strong, nonatomic) NSArray *doors;

// touch
@property (assign) GridCoord cellFromLastTouch;

// puzzles defined in Puzzles.plist
+ (CCScene *)sceneWithPuzzle:(int)puzzle;









@end
