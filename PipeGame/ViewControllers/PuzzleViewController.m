//
//  PuzzleMenuViewController.m
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "PuzzleViewController.h"
#import "PuzzleLayer.h"
#import "TextureUtils.h"

@interface PuzzleViewController ()

@end

@implementation PuzzleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load our textures
    [TextureUtils loadTextures];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[CCDirector sharedDirector] setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // run cocos2d scene
    CCDirector *director = [CCDirector sharedDirector];
    if(director.runningScene) {
        [director replaceScene:[PuzzleLayer sceneWithPuzzle:self.puzzle]];
    }
    else {
        [director runWithScene:[PuzzleLayer sceneWithPuzzle:self.puzzle]];
    }
}

@end
