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

static NSString *const kImageArmUnit = @"armUnit.png";
static GLubyte const kBackgroundTileLayerOpacity = 80;


@implementation PuzzleLayer

+ (CCScene *)sceneWithPuzzle:(int)puzzle
{
    CCScene *scene = [CCScene node];
    
    PuzzleLayer *puzzleLayer = [[PuzzleLayer alloc] initWithColor:ccc4(0, 0, 0, 255) puzzle:puzzle];
    
    [scene addChild:puzzleLayer];
       
    return scene;
}

//- (id)initWithPuzzle:(int)puzzle
- (id)initWithColor:(ccColor4B)color puzzle:(int)puzzle
{
//    self = [super init];
    self = [super initWithColor:color];
    if (self) {
        NSString *tileMapName = [PuzzleLayer tiledMapNameForPuzzle:puzzle];
        
        [self setIsTouchEnabled:YES];

        // tile map
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:tileMapName];
        [self addChild:_tileMap];
        
        _gridSize = [GridUtils gridCoordFromSize:_tileMap.mapSize];
        _gridOrigin = [PuzzleLayer sharedGridOrigin];
        
        // cell object library
        _cellObjectLibrary = [[CellObjectLibrary alloc] initWithGridSize:_gridSize];
        
        // hand
        NSMutableDictionary *entryData = [_tileMap objectNamed:kTLDObjectEntry groupNamed:kTLDGroupMeta];
        _entry = [[PGEntry alloc] initWithEntry:entryData tileMap:_tileMap];
        _handNode = [[HandNode alloc] initWithContentSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit)];
        
        _handNode.position = [GridUtils absolutePositionForGridCoord:_entry.cell unitSize:kSizeGridUnit origin:_gridOrigin];
        _handNode.pipeLayers = @[_entry.pipeLayer];
        [_tileMap addChild:_handNode z:[_tileMap layerNamed:_entry.pipeLayer].zOrder];

        [_handNode setDirectionFacing:_entry.direction];
        
        _handEntersFrom = [GridUtils oppositeDirection:_entry.direction];
        _isHandNodeSelected = NO;
        
        // layer color
        self.color = [PGTiledUtils pipeColorAtLayer:_entry.pipeLayer];
        
        // arm
        _armNodes = [NSMutableArray array];
        
        // move to layer
        [self moveToLayer:_entry.pipeLayer];

        // connections
        NSMutableArray *connections = [_tileMap objectsWithName:kTLDObjectConnection groupName:kTLDGroupMeta];
        for (NSMutableDictionary *connection in connections) {
            ConnectionNode *connectionNode = [ConnectionNode nodeWithConnection:connection tileMap:self.tileMap];
            [self.cellObjectLibrary addNodeToLibrary:connectionNode cell:connectionNode.cell];
        }
    }
    return self;
}

+ (NSString *)tiledMapNameForPuzzle:(int)puzzle
{
    return [NSString stringWithFormat:@"map%i.tmx", puzzle];
}

- (void)registerWithNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(handleArmNodeTouched:) name:kPGNotificationArmNodeTouched object:nil];
    [notificationCenter addObserver:self selector:@selector(handleHandNodeTouched:) name:kPGNotificationHandNodeTouched object:nil];
}

+ (CGPoint)sharedGridOrigin
{
    return CGPointMake(0, 0);
}

- (void)moveToLayer:(NSString *)layerName
{
    // hand 
    if (self.handNode == nil) {
        NSLog(@"warning: can't use moveToLayer before hand node has been created");
        return;
    }
    self.handNode.pipeLayers = @[layerName];
    [self.tileMap reorderChild:self.handNode z:[self.tileMap layerNamed:layerName].zOrder];
    
    // tiles
    [self.tileMap performBlockForAllTiles:^(CCTMXLayer *layer, CCSprite *tile) {
        if ([self.handNode isAtPipeLayer:layer.layerName]) {
            tile.opacity = 255;
        }         else {
            tile.opacity = kBackgroundTileLayerOpacity;
        }
    }];
    
    // arms
    for (ArmNode *node in self.armNodes) {
        if ([node isAtPipeLayer:layerName]) {
            node.sprite.opacity = 255;
        }
        else {
            node.sprite.opacity = kBackgroundTileLayerOpacity;
        }
    }
    
    // layer color
    self.color = [PGTiledUtils pipeColorAtLayer:layerName];

}

- (CCTMXLayer *)currentPipeLayer
{
    return [self.tileMap layerNamed:[self currentPipeLayerName]];
}

- (NSString *)currentPipeLayerName
{
    return self.handNode.firstPipeLayer;
}


#pragma mark - scene management

-(void) onEnterTransitionDidFinish
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [self registerWithNotifications];
}
-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


# pragma mark - draw grid

- (void)draw
{
    // grid
    ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
    [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:_gridOrigin];
}

# pragma mark - targeted touch delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord touchCell = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
    
    if (self.isHandNodeSelected) {
        if ([GridUtils isCell:self.cellFromLastTouch equalToCell:touchCell] == NO) {
            self.cellFromLastTouch = touchCell;
            [self tryGridTouchAtPosition:touchPosition cell:touchCell];
        }
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.isHandNodeSelected == YES) {
        self.isHandNodeSelected = NO;
        [self tintHandAndArm:ccWHITE];
        
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
    if ([connectionNode isAtPipeLayer:self.handNode.firstPipeLayer]) {
        for (NSString *pipeLayer in connectionNode.pipeLayers) {
            if ([pipeLayer isEqualToString:self.handNode.firstPipeLayer] == NO) {
                
                // TODO: working on creating arm through graphic
                if ([GridUtils isCell:self.handNode.cell equalToCell:[self lastArmNode].cell] == NO) {
                    [self addArmNodeAtCell:self.handNode.cell movingDirection:kDirectionThrough];
                }
                else {
                    [self removeArmNodesFromIndex:(self.armNodes.count - 1)];
                }
                
                [self moveToLayer:pipeLayer];
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - cell node touches

- (void)handleHandNodeTouched:(NSNotification *)notification
{
    self.isHandNodeSelected = YES;
    [self tintHandAndArm:[ColorUtils tintArmSelected]];
}

- (void)handleArmNodeTouched:(NSNotification *)notification
{
    ArmNode *nodeTouched = (ArmNode *)notification.object;
    
    if ([nodeTouched isAtPipeLayer:[self currentPipeLayerName]]) {
        CGPoint nodePosition = nodeTouched.position;
        int touchedIndex = [self.armNodes indexOfObject:nodeTouched];
        
        // move hand and rotate to correct direction
        self.handNode.position = nodePosition;
        kDirection shouldFace;
        if (touchedIndex > 0) {
            ArmNode *newLastArmNode = [self.armNodes objectAtIndex:touchedIndex - 1];
            shouldFace = [GridUtils directionFromStart:[newLastArmNode cell] end:[nodeTouched cell]];
        }
        else {
            shouldFace = [GridUtils oppositeDirection:self.handEntersFrom];
        }
        [self.handNode setDirectionFacing:shouldFace];
        
        // remove arm nodes
        [self removeArmNodesFromIndex:touchedIndex];
    }
}


#pragma mark - hand

- (BOOL)tryGridTouchAtPosition:(CGPoint)touchPosition cell:(GridCoord)touchCell
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
                    self.handNode.position = [GridUtils absolutePositionForGridCoord:touchCell unitSize:kSizeGridUnit origin:self.gridOrigin];
                    
                    return YES;
                }
            }
            // handle touch in a cell with an arm unit (rewind)
            else {
                ArmNode *armNodeTouched = [self.cellObjectLibrary firstNodeOfKind:[ArmNode class] atCell:touchCell atPipeLayer:[self currentPipeLayerName]];
                
                if ([armNodeTouched isEqual:self.armNodes.lastObject]) {
                    
                    [self removeArmNodesFromIndex:(self.armNodes.count - 1)];
                    
                    kDirection shouldFace;
                    if ([self lastArmNode] != nil) {
                        shouldFace = [GridUtils directionFromStart:[self lastArmNode].cell end:touchCell];
                    }
                    else {
                        shouldFace = self.entry.direction;
                    }
                    [self.handNode setDirectionFacing:shouldFace];
                    self.handNode.position = [GridUtils absolutePositionForGridCoord:touchCell unitSize:kSizeGridUnit origin:self.gridOrigin];
                }
            }
        }
    }
    return NO;
}

- (void)tintHandAndArm:(ccColor3B)color
{
    self.handNode.sprite.color = color;
    for (ArmNode *arm in self.armNodes) {
        arm.sprite.color = color;
    }
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
            newArmNode = [[ArmNode alloc] initInCell:cell firstExit:firstExit secondExit:direction pipeLayer:self.handNode.firstPipeLayer ];
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
            newArmNode = [[ArmNode alloc] initForLayerConnectionInCell:cell exit:exit pipeLayer:self.handNode.firstPipeLayer];
        }
    }
    else {
        if (direction != kDirectionThrough) {
            newArmNode = [[ArmNode alloc] initInCell:cell firstExit:self.handEntersFrom secondExit:direction pipeLayer:self.handNode.firstPipeLayer];
        }
        else {
            NSLog(@"warning: moving through on first cell needs implementation");
        }
    }
    
    if (self.isHandNodeSelected) {
        newArmNode.sprite.color = [ColorUtils tintArmSelected];
    }
    
    // need to add as child, to the armNodes stack and to the cell object library
    [self.tileMap addChild:newArmNode z:[self.tileMap layerNamed:[self.handNode.pipeLayers objectAtIndex:0]].zOrder];
    
    [self.armNodes addObject:newArmNode];
    [self.cellObjectLibrary addNodeToLibrary:newArmNode cell:cell];
}

- (void)removeArmNodesFromIndex:(int)removeFromIndex
{
    int lastIndex = [self.armNodes count] - 1;
    for (int i = lastIndex; i >= removeFromIndex; i--) {
        ArmNode *removeArmNode = (ArmNode *)[self.armNodes objectAtIndex:i];
        GridCoord removeArmCell = [removeArmNode cell];
        [self.cellObjectLibrary removeNodeFromLibrary:removeArmNode cell:removeArmCell];
        [self.armNodes removeLastObject];
        [self.tileMap removeChild:removeArmNode cleanup:YES];
    }
}

- (BOOL)isArmNodeAtCell:(GridCoord)cell
{
    NSMutableArray *cellNodes = [self.cellObjectLibrary nodesForCell:cell];
    for (CellNode *node in cellNodes ) {
        if ([node isKindOfClass:[ArmNode class]]) {
            if ([node isAtPipeLayer:[self currentPipeLayerName]]) {
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
    return [self.tileMap testConditionForTileAtCell:cell layer:[self currentPipeLayer] condition:^BOOL(CCSprite *tile, NSDictionary *tileProperties) {
        
        NSString *directionString = [GridUtils directionStringForDirection:direction];
        NSNumber *canMove = [tileProperties objectForKey:directionString];
        if ([canMove boolValue]) {
            return YES;
        }
        return NO;
    }];    
}

- (BOOL)isCellBlocked:(GridCoord)cell
{
    NSMutableArray *objects = [self.cellObjectLibrary nodesForCell:cell];
    for (CellNode *node in objects) {
        if ([node isAtPipeLayer:self.handNode.firstPipeLayer]) {
            if (node.shouldBlockMovement) {
                return YES;
            }
        }
    }
    return NO;
}

@end
