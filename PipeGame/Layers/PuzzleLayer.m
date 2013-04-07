//
//  PuzzleLayer.m
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "PuzzleLayer.h"
#import "GameConstants.h"
#import "DataUtils.h"
#import "ArmNode.h"
#import "HandNode.h"
#import "GridUtils.h"
#import "TextureUtils.h"
#import "CellObjectLibrary.h"
#import "ColorUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "ConnectionNode.h"
#import "PGEntry.h"
#import "PGTiledUtils.h"
#import "BackgroundLayer.h"
#import "CoverPoint.h"

static NSString *const kImageArmUnit = @"armUnit.png";
static GLubyte const kBackgroundTileLayerOpacity = 170;
static ccTime const kMoveToDuration = 0.4;
static CGFloat const kLayerScale = 0.05;

NSString *const kPGNotificationArmStackChanged = @"ArmStackChanged";


@implementation PuzzleLayer

+ (CCScene *)sceneWithPuzzle:(int)puzzle
{
    CCScene *scene = [CCScene node];
    
    PuzzleLayer *puzzleLayer = [[PuzzleLayer alloc] initWithPuzzle:puzzle];
    
    // background
    CGSize landscape = [GameConstants landscapeScreenSize];
    puzzleLayer.backgroundLayer = [[BackgroundLayer alloc] initWithColor:ccc4(0, 0, 0, 255) width:landscape.width height:landscape.height];
    [puzzleLayer.backgroundLayer tintToColor:[PGTiledUtils pipeColorAtLayer:[puzzleLayer currentLayer]] duration:kMoveToDuration];
    
    [scene addChild:puzzleLayer.backgroundLayer];
    [scene addChild:puzzleLayer];
    
    return scene;
}

- (CGPoint)convertTouchToPuzzleSpace:(CGPoint)touchPosition
{
    return ccp(touchPosition.x - self.position.x, touchPosition.y - self.position.y);
}

//- (id)initWithPuzzle:(int)puzzle
- (id)initWithPuzzle:(int)puzzle
{
//    self = [super init];
    self = [super init];
    if (self) {
        [self setIsTouchEnabled:YES];
        
        // tile map
        NSString *tileMapName = [PuzzleLayer tiledMapNameForPuzzle:puzzle];
        
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:tileMapName];
        [self addChild:_tileMap];
        
        _gridSize = [GridUtils gridCoordFromSize:_tileMap.mapSize];
        
        // cell object library
        _cellObjectLibrary = [[CellObjectLibrary alloc] initWithGridSize:_gridSize];
        
        // hand
        NSMutableDictionary *entryData = [_tileMap objectNamed:kTLDObjectEntry groupNamed:kTLDGroupMeta];
        _entry = [[PGEntry alloc] initWithEntry:entryData tileMap:_tileMap];
        _handNode = [[HandNode alloc] init];
        
        _handNode.position = [GridUtils absolutePositionForGridCoord:_entry.cell unitSize:kSizeGridUnit origin:self.position ];
        self.handNode.cell = _entry.cell; // TODO: hand node should have an initializer
        _handNode.layer = _entry.layer;
        [_tileMap addChild:_handNode z:kLayerHand2];

        [_handNode setDirectionFacing:_entry.direction];
        
        _handEntersFrom = [GridUtils oppositeDirection:_entry.direction];
        _isHandNodeSelected = NO;
        
        _handNode.transferResponder = self;
        
        [_cellObjectLibrary addNode:_handNode cell:_handNode.cell];
        
        // arm
        _armNodes = [NSMutableArray array];
        
        // connections
        NSMutableArray *connections = [_tileMap objectsWithName:kTLDObjectConnection groupName:kTLDGroupMeta];
        for (NSMutableDictionary *connection in connections) {
            ConnectionNode *connectionNode = [[ConnectionNode alloc] initWithConnection:connection tiledMap:_tileMap puzzleOrigin:self.position];
            [self.cellObjectLibrary addNode:connectionNode cell:connectionNode.cell];
        }
        
        // rats (cover point)
        _rats = [NSMutableArray array];
        NSMutableArray *rats = [_tileMap objectsWithName:kTLDObjectCoverPoint groupName:kTLDGroupMeta];
        for (NSMutableDictionary *rat in rats) {
            CoverPoint *ratNode = [[CoverPoint alloc] initWithCoverPoint:rat tiledMap:_tileMap puzzleOrigin:self.position];
            [self.rats addObject:ratNode];
            [_tileMap addChild:ratNode];
            [self.cellObjectLibrary addNode:ratNode cell:ratNode.cell];
        }
        
        // move to layer
        [self moveToLayer:_entry.layer];
    }
    return self;
}

+ (NSString *)tiledMapNameForPuzzle:(int)puzzle
{
    return [NSString stringWithFormat:@"map%i.tmx", puzzle];
}

- (void)registerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(handleHandNodeTouched:) name:kPGNotificationHandNodeTouched object:nil];
    [notificationCenter addObserver:self selector:@selector(handleHandNodeMoved) name:kPGNotificationHandNodeMoved object:nil];
}

// use this for individual reordering, for example adding an arm unit
- (int)zOrderForChild:(id)child topLayer:(int)topLayer
{
    BOOL reverse = topLayer == 1;
    
    if ([child isKindOfClass:[CCTMXLayer class]]) {
        CCTMXLayer *layer = (CCTMXLayer *)child;
        if ([layer.layerName isEqualToString:@"pipes1"]) {
            if (reverse) {
                return kLayerPipe2;
            }
            else {
                return kLayerPipe1;
            }
        }
        else {
            if (reverse) {
                return kLayerPipe1;
            }
            else {
                return kLayerPipe2;
            }
        }
    }
    else if ([child isKindOfClass:[HandNode class]]) {
        return kLayerHand2;
    }
    else if ([child isKindOfClass:[ArmNode class]]) {
        ArmNode *arm = (ArmNode *)child;
        if (arm.layer == 1) {
            if (reverse) {
                return kLayerHand2;
            }
            else {
                return kLayerHand1;
            }
        }
        else {
            if (reverse) {
                return kLayerHand1;
            }
            else {
                return kLayerHand2;
            }
        }
    }
    else if ([child isKindOfClass:[CoverPoint class]]) {
        CoverPoint *rat = (CoverPoint *)child;
        if (rat.layer == 1) {
            if (reverse) {
                return kLayerOver2;
            }
            else {
                return kLayerOver1;
            }
        }
        else {
            if (reverse) {
                return kLayerOver1;
            }
            else {
                return kLayerOver2;
            }
        }
    }
    NSLog(@"warning: child not recognized");
    return -1;
}

// order all children, for example when moving layers
- (void)orderChildren:(int)topLayer
{
    for (id child in self.tileMap.children) {
        int z = [self zOrderForChild:child topLayer:topLayer];
        [self.tileMap reorderChild:child z:z];
    }
}

- (void)moveToLayer:(int)toLayer 
{
    [self.backgroundLayer tintToColor:[PGTiledUtils pipeColorAtLayer:toLayer] duration:kMoveToDuration];
    
    // hand 
    if (self.handNode == nil) {
        NSLog(@"warning: can't use moveToLayer before hand node has been created");
        return;
    }

    self.handNode.layer = toLayer;
    
    // arm and rats
    for (CellNode *node in [self.armNodes arrayByAddingObjectsFromArray:self.rats]) {
               
        if (node.layer == toLayer) {
            CCFadeTo *brighten = [CCFadeTo actionWithDuration:kMoveToDuration opacity:255];
            [node.sprite runAction:brighten];
        }
        else {
            CCFadeTo *darken = [CCFadeTo actionWithDuration:kMoveToDuration opacity:kBackgroundTileLayerOpacity];
            [node.sprite runAction:darken];
        }
    }

    // tiles
    [self.tileMap performBlockForAllTiles:^(CCTMXLayer *layer, CCSprite *tile) {
        if (tile != nil) {
            if ([self.handNode.layerName isEqualToString:layer.layerName]) {
                CCFadeTo *brighten = [CCFadeTo actionWithDuration:kMoveToDuration opacity:255];
                [tile runAction:brighten];
            }
            else {
                CCFadeTo *darken = [CCFadeTo actionWithDuration:kMoveToDuration opacity:kBackgroundTileLayerOpacity];
                [tile runAction:darken];
            }
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPGNotificationArmStackChanged object:self.armNodes];
    
    [self orderChildren:toLayer];
}

- (CCTMXLayer *)currentTMXLayer
{
    return [self.tileMap layerNamed:[self currentPipeLayerName]];
}

- (NSString *)currentPipeLayerName
{
    return self.handNode.layerName;
}

-(int) currentLayer
{
    return self.handNode.layer;
}


#pragma mark - scene management

-(void) onEnterTransitionDidFinish
{
    [self registerNotifications];
}
-(void) onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


# pragma mark - draw grid

//- (void)draw
//{
//    // grid
//    ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
//    [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:self.position];
//}

# pragma mark - touch delegate

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

{
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPosition = [self convertTouchToNodeSpace:touch];        
        GridCoord touchCell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit origin:self.position];

        if (self.isHandNodeSelected) {
            if ([GridUtils isCell:self.cellFromLastTouch equalToCell:touchCell] == NO) {
                self.cellFromLastTouch = touchCell;
                [self tryGridTouchAtCell:touchCell];
            }
        }
    }
    
    // pan
    else {
        UITouch *touch = [touches anyObject];
        
        CGPoint previousPosition = [touch previousLocationInView:touch.view];
        previousPosition = [[CCDirector sharedDirector] convertToGL:previousPosition];
        previousPosition = [self convertToNodeSpace:previousPosition];
        
        CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
        CGPoint translation = ccpSub(touchPosition, previousPosition);
        [self panWithTranslation:translation];
    }
}

- (void)panWithTranslation:(CGPoint)translation {
    self.position = ccpAdd(self.position, translation);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isHandNodeSelected == YES) {
        self.isHandNodeSelected = NO;
        [self tintHandAndArm:ccWHITE];
        
        // try a connection if we overlap one
        NSMutableArray *cellObjects = [self.cellObjectLibrary nodesForCell:self.handNode.cell];
        NSUInteger connectionIndex = [cellObjects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [obj isKindOfClass:[ConnectionNode class]];
        }];
        if (connectionIndex != NSNotFound) {
            ConnectionNode *connectionNode = [cellObjects objectAtIndex:connectionIndex];
            [self tryConnection:connectionNode];
        }
    }
}

- (BOOL)tryConnection:(ConnectionNode *)connectionNode
{
                    
    if (![GridUtils isCell:self.handNode.cell equalToCell:[self lastArmNode].cell]) {
        [self addArmNodeAtCell:self.handNode.cell movingDirection:kDirectionThrough];
    }
    else {
        [self removeArmNodesFromIndex:(self.armNodes.count - 1)];
    }
    
    // TODO: will need to check if opposite layer is occupied
    [self moveToLayer:[PGTiledUtils oppositeLayer:self.currentLayer]];
    return YES;    
}

#pragma mark - cell node touches

- (void)handleHandNodeTouched:(NSNotification *)notification
{
    self.isHandNodeSelected = YES;
    [self tintHandAndArm:[ColorUtils tintArmSelected]];
}

#pragma mark - hand

- (BOOL)tryGridTouchAtCell:(GridCoord)touchCell
{
    // handle for touch within grid
    if ([GridUtils isCellInBounds:touchCell gridSize:self.gridSize]) {
        
        // if we are touching a new cell
        if ([GridUtils isCell:touchCell equalToCell:self.handNode.cell] == NO) {
            
            // handle touch in cell with no arm unit
            if ([self isArmNodeAtCell:touchCell] == NO) {
                if ([self isLinearPathFreeBetweenStart:self.handNode.cell end:touchCell]) {
                    
                    // arm units
                    [GridUtils performBlockBetweenFirstCell:self.handNode.cell secondCell:touchCell block:^(GridCoord cell, kDirection direction) {
                        
                        if ([GridUtils isCell:cell equalToCell:touchCell] == NO) {
                            [self addArmNodeAtCell:cell movingDirection:direction];
                        }
                    }];
                    
                    // hand sprite
                    kDirection shouldFace = [GridUtils directionFromStart:self.handNode.cell end:touchCell];
                    [self.handNode setDirectionFacing:shouldFace];
                    [self.handNode moveTo:touchCell puzzleOrigin:self.position];
                    
                    return YES;
                }
            }
            // handle touch in a cell with an arm unit (rewind)
            else {
                ArmNode *armNodeTouched = [self.cellObjectLibrary firstNodeOfKind:[ArmNode class] atCell:touchCell layer:self.currentLayer];
                if ([armNodeTouched isEqual:self.armNodes.lastObject]) {
                    
                    [self removeArmNodesFromIndex:(self.armNodes.count - 1)];
                    
                    kDirection shouldFace;
                    if ([self lastArmNode] != nil) {
                        if ([GridUtils isCell:[self lastArmNode].cell equalToCell:touchCell]) {
                            ArmNode *secondTolastArmNode = [self.armNodes objectAtIndex:self.armNodes.count - 2];
                            shouldFace = [GridUtils directionFromStart: secondTolastArmNode.cell end:touchCell];
                        }
                        else {
                            shouldFace = [GridUtils directionFromStart:[self lastArmNode].cell end:touchCell];
                        }
                    }
                    else {
                        shouldFace = self.entry.direction;
                    }
                    [self.handNode setDirectionFacing:shouldFace];
                    [self.handNode moveTo:touchCell puzzleOrigin:self.position];
                }
            }
        }
    }
    return NO;
}

-(void) tintHandAndArm:(ccColor3B)color
{
    self.handNode.sprite.color = color;
    for (ArmNode *arm in self.armNodes) {
        arm.sprite.color = color;
    }
}

-(void) handleHandNodeMoved
{

}

#pragma mark - arm

- (void)addArmNodeAtCell:(GridCoord)cell movingDirection:(kDirection)direction
{  
    ArmNode *newArmNode;
    if ([self.armNodes count] > 0) {
        ArmNode *lastArmNode = [self.armNodes lastObject];
        
        // standard arm node
        BOOL armOverlapsLastArm = [GridUtils isCell:cell equalToCell:[lastArmNode cell]];
        if (direction != kDirectionThrough && !armOverlapsLastArm) {
            kDirection firstExit = [GridUtils directionFromStart:cell end:[lastArmNode cell]];
            newArmNode = [[ArmNode alloc] initInCell:cell firstExit:firstExit secondExit:direction layer:self.handNode.layer puzzleOrigin:self.position];
        }
        // arm node moving though layer
        else {
            kDirection exit;
            if (armOverlapsLastArm) {
                exit = direction;
            }
            else {
                exit = [GridUtils directionFromStart:self.handNode.cell end:[lastArmNode cell]];
            }
            newArmNode = [[ArmNode alloc] initForLayerConnectionInCell:cell exit:exit layer:self.handNode.layer puzzleOrigin:self.position];
        }
    }
    else {
        if (direction != kDirectionThrough) {
            newArmNode = [[ArmNode alloc] initInCell:cell firstExit:self.handEntersFrom secondExit:direction layer:self.handNode.layer puzzleOrigin:self.position];
        }
        else {
            NSLog(@"warning: moving through on first cell needs implementation");
        }
    }
    
    if (self.isHandNodeSelected) {
        newArmNode.sprite.color = [ColorUtils tintArmSelected];
    }
    
    // need to add as child, to the armNodes stack and to the cell object library
    [self.tileMap addChild:newArmNode z:[self zOrderForChild:newArmNode topLayer:[self currentLayer]]];
    
    [self.armNodes addObject:newArmNode];
    [self.cellObjectLibrary addNode:newArmNode cell:cell];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPGNotificationArmStackChanged object:self.armNodes];
}

- (void)removeArmNodesFromIndex:(int)removeFromIndex
{
    int lastIndex = [self.armNodes count] - 1;
    for (int i = lastIndex; i >= removeFromIndex; i--) {
        ArmNode *removeArmNode = (ArmNode *)[self.armNodes objectAtIndex:i];
        GridCoord removeArmCell = [removeArmNode cell];
        [self.cellObjectLibrary removeNode:removeArmNode cell:removeArmCell];
        [self.armNodes removeLastObject];
        [self.tileMap removeChild:removeArmNode cleanup:YES];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPGNotificationArmStackChanged object:self.armNodes];
}

- (BOOL)isArmNodeAtCell:(GridCoord)cell
{
    NSMutableArray *cellNodes = [self.cellObjectLibrary nodesForCell:cell];
    for (CellNode *node in cellNodes ) {
        if ([node isKindOfClass:[ArmNode class]]) {
            if (node.layer == self.currentLayer) {
                return YES;
            }   
        }
    }
    return NO;
}

-(ArmNode *)lastArmNode
{
    if ([self.armNodes count] < 1) {
        NSLog(@"warning: no arm nodes in self.armNodes");
    }
    ArmNode *armNode = self.armNodes.lastObject;
    return armNode;
}


#pragma mark - transfer responder

-(void) transferNode:(CellNode *)node toCell:(GridCoord)moveTo fromCell:(GridCoord)moveFrom
{
    [self.cellObjectLibrary transferNode:node toCell:moveTo fromCell:moveFrom];
}


#pragma mark - helpers

- (BOOL)isLinearPathFreeBetweenStart:(GridCoord)start end:(GridCoord)end
{
    // base case - if we reach the end of the path with no obstructions, it's a valid move
    if ([GridUtils isCell:start equalToCell:end] && ([self isCellBlocked:start] == NO)) {
        return YES;
    }
    
    // if path has not reached the end, check for valid direction, cell blocked, and pipe exits
    kDirection direction = [GridUtils directionFromStart:start end:end];
    if (direction == kDirectionNone || [self isCellBlocked:start] || ([self canExitCell:start movingDirection:direction] == NO)) {
        return NO;
    }
    
    // path has not reached the end and is stil free, recursive call with next cell
    else {
        GridCoord newStart = [GridUtils stepInDirection:direction fromCell:start];
        return [self isLinearPathFreeBetweenStart:newStart end:end];
    }
}

- (BOOL)canExitCell:(GridCoord)cell movingDirection:(kDirection)direction
{
    return [self.tileMap testConditionForTileAtCell:cell layer:[self currentTMXLayer] condition:^BOOL(CCSprite *tile, NSDictionary *tileProperties) {
        
        NSString *directionString = [GridUtils directionStringForDirection:direction];
        NSNumber *canMove = [tileProperties objectForKey:directionString];
        return ([canMove boolValue]);
    }];    
}

- (BOOL)isCellBlocked:(GridCoord)cell
{
    NSMutableArray *objects = [self.cellObjectLibrary nodesForCell:cell];
    for (CellNode *node in objects) {
        if (node.layer == self.handNode.layer) {
            if (node.shouldBlockMovement) {
                return YES;
            }
        }
    }
    return NO;
}

@end
