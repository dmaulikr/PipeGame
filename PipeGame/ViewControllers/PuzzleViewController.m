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

    CCDirector *director = [CCDirector sharedDirector];
    
    // load our textures
    [TextureUtils loadTextures];
    
    // Run whatever scene we'd like to run here.
    if(director.runningScene) {
        [director replaceScene:[PuzzleLayer sceneWithPuzzle:2]];
    }
    else {
        [director runWithScene:[PuzzleLayer sceneWithPuzzle:2]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[CCDirector sharedDirector] setDelegate:nil];
}

@end
