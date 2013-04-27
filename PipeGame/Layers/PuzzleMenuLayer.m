//
//  PuzzleMenuLayer.m
//  PipeGame
//
//  Created by John Saba on 4/17/13.
//
//

#import "PuzzleMenuLayer.h"
#import "PathUtils.h"

@implementation PuzzleMenuLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    PuzzleMenuLayer *puzzleMenuLayer = [[PuzzleMenuLayer alloc] init];
    [scene addChild:puzzleMenuLayer];
    return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self registerWithTouchDispatcher];
        self.maps = [NSMutableArray array];
        
        NSArray *maps = [PathUtils tileMapNames];
        int i = 0;
        for (NSString *map in maps) {
            CGSize winSize = [CCDirector sharedDirector].winSize;
            CCLabelTTF *mapLabel = [CCLabelTTF labelWithString:map fontName:@"Helvetica" fontSize:30];
            mapLabel.position = ccp(winSize.width/2, mapLabel.boundingBox.size.height/2 + (i * mapLabel.boundingBox.size.height));
            [self addChild:mapLabel];
            [self.maps addObject:mapLabel];
        }
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    for (NSString *map in self.maps) {
        NSLog(@"map: %@", map);
    }
    
}

@end
