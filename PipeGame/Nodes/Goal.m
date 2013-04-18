//
//  Goal.m
//  PipeGame
//
//  Created by John Saba on 4/14/13.
//
//

#import "Goal.h"
#import "TextureUtils.h"
#import "PGTiledUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "CellObjectLibrary.h"
#import "HandNode.h"

NSString *const kTLDObjectGoal = @"goal";

@implementation Goal

- (id)initWithGoal:(NSMutableDictionary *)goal tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        
        self.sprite = [self createAndCenterSpriteNamed:kImageNameGoal];
        [self addChild:self.sprite];
                
        self.layer = [[goal valueForKey:kTLDPropertyLayer] intValue];
        
        self.cell = [tiledMap gridCoordForObject:goal];
        self.position = [GridUtils absolutePositionForGridCoord:self.cell unitSize:kSizeGridUnit origin:origin];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCellNodeLibraryChangedContents:) name:kPGNotificationCellNodeLibraryChangedContents object:nil];
    }
    return self;
}

- (void)handleCellNodeLibraryChangedContents:(NSNotification *)notification
{
    CellObjectLibrary *library = notification.object;
    if ([library containsNodeOfKind:[HandNode class] layer:self.layer cell:self.cell]) {
        NSLog(@"WIN");
    }
}

@end
