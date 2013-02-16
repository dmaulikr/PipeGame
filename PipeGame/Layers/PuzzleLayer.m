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

static NSString *const kImageArmUnit = @"armUnit.png";


@implementation PuzzleLayer

+ (CCScene *)sceneWithPuzzle:(int)puzzle
{
    CCScene *scene = [CCScene node];
    
    PuzzleLayer *puzzleLayer = [[PuzzleLayer alloc] initWithPuzzle:puzzle];
    [scene addChild:puzzleLayer];
       
    return scene;
}

- (id)initWithPuzzle:(int)puzzle 
{
    self = [super init];
    if (self) {

        [self setIsTouchEnabled:YES];
        
        _gridSize = [DataUtils puzzleSize:puzzle];
        _gridOrigin = [PuzzleLayer sharedGridOrigin];
        
        // tile map
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"pipeTileset1.tmx"];
        [self addChild:_tileMap];
        
        // cell object library
        _cellObjectLibrary = [[CellObjectLibrary alloc] initWithGridSize:_gridSize];
        
        // hand
        _handNode = [[HandNode alloc] initWithContentSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit)];
        _handEntryCoord = [DataUtils puzzleEntryCoord:puzzle];
        _handNode.position = [GridUtils absolutePositionForGridCoord:_handEntryCoord unitSize:kSizeGridUnit origin:_gridOrigin];
        [self addChild:_handNode];
        
        kDirection entryDirection = [DataUtils puzzleEntryDirection:puzzle];
        [_handNode setDirectionFacing:entryDirection];
        _lastHandCell = _handEntryCoord;
        
        _handEntersFrom = [GridUtils oppositeDirection:entryDirection];
        _isHandNodeSelected = NO;
        
        // stack of arm nodes
        _armNodes = [NSMutableArray array];
        
        
        
        
        
        
        // testing tile maps
        //////////////////////////////////////////////////////////////////////////////////////////
        
//        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"pipeTileset1.tmx"];
//        [self addChild:_tileMap z:1];
        
//        CCTMXTiledMap *tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"pipeTileset1.tmx"];
//        [self addChild:tileMap z:-1];
//        CCTMXLayer *tileLayer1 = [tileMap layerNamed:@"Tile Layer 1"];
//        
//        CGPoint tileCoord = [GridUtils tiledCoordForPosition:CGPointMake(234, 111) tileMap:tileMap origin:_gridOrigin];
//        int tileGid = [tileLayer1 tileGIDAt:tileCoord];
//        if (tileGid) {
//            NSDictionary *properties = [tileMap propertiesForGID:tileGid];
//            NSLog(@"properties for gid %i: %@: ", tileGid, properties);
//        }
        //////////////////////////////////////////////////////////////////////////////////////////

    }
    return self;
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


# pragma mark - draw

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
    }
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


#pragma mark - hand

- (BOOL)tryGridTouchAtPosition:(CGPoint)touchPosition cell:(GridCoord)touchCell
{
    // handle for touch within grid
    if ([GridUtils isCellInBounds:touchCell gridSize:self.gridSize]) {
        
        // touch a cell to move to its position if path is free and in a line
        GridCoord moveToCell = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
        
        if ([GridUtils isCell:moveToCell equalToCell:self.handNode.cell] == NO) {
            if ([self isLinearPathFreeBetweenStart:self.handNode.cell end:moveToCell]) {
                
                // arm units
                [GridUtils performBlockBetweenFirstCell:self.handNode.cell secondCell:moveToCell block:^(GridCoord cell, kDirection direction) {
                    
                    if ([GridUtils isCell:cell equalToCell:moveToCell] == NO) {
                        [self addArmNodeAtCell:cell movingDirection:direction];
                    }
                }];
                
                // hand sprite
                kDirection shouldFace = [GridUtils directionFromStart:self.handNode.cell end:moveToCell];
                [self.handNode setDirectionFacing:shouldFace];
                self.handNode.position = [GridUtils absolutePositionForGridCoord:moveToCell unitSize:kSizeGridUnit origin:self.gridOrigin];
                
                return YES;
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
        kDirection firstExit = [GridUtils directionFromStart:cell end:[lastArmNode cell]];
        newArmNode = [[ArmNode alloc] initInCell:cell firstExit:firstExit secondExit:direction];
    }
    else {
        newArmNode = [[ArmNode alloc] initInCell:cell firstExit:self.handEntersFrom secondExit:direction];
    }
    
    if (self.isHandNodeSelected) {
        newArmNode.sprite.color = [ColorUtils tintArmSelected];
    }
    
    // need to add as child, to the armNodes stack and to the cell object library
    [self addChild:newArmNode];
    [self.armNodes addObject:newArmNode];
    [self.cellObjectLibrary addObjectToLibrary:newArmNode cell:cell];
}

- (void)removeArmNodesFromIndex:(int)removeFromIndex
{
    int lastIndex = [self.armNodes count] - 1;
    for (int i = lastIndex; i >= removeFromIndex; i--) {
        ArmNode *removeArmNode = (ArmNode *)[self.armNodes objectAtIndex:i];
        GridCoord removeArmCell = [removeArmNode cell];
        [self.cellObjectLibrary removeObjectFromLibrary:removeArmNode cell:removeArmCell];
        [self.armNodes removeLastObject];
        [self removeChild:removeArmNode cleanup:YES];
    }
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
    CCTMXLayer *tileLayer1 = [self.tileMap layerNamed:@"Tile Layer 1"];
    
    GridCoord tileCoord = [GridUtils tiledGridCoordForGameGridCoord:cell tileMapHeight:self.tileMap.mapSize.height];
    
    int tileGid = [tileLayer1 tileGIDAt:CGPointMake(tileCoord.x, tileCoord.y)];
    if (tileGid) {
        NSDictionary *properties = [self.tileMap propertiesForGID:tileGid];
        
        NSString *directionString = [GridUtils directionStringForDirection:direction];
        NSNumber *canMove = [properties objectForKey:directionString];
        if (canMove) {
            if ([canMove boolValue]) {
                return YES;
            }
        }
    }

    return NO;
}

- (BOOL)isCellBlocked:(GridCoord)cell
{
    NSMutableArray *objects = [self.cellObjectLibrary objectsForCell:cell];
    for (CellNode *node in objects) {
        if (node.shouldBlockMovement) {
            return YES;
        }
    }
    return NO;
}


@end
