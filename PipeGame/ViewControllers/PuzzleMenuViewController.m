//
//  PuzzleMenuViewController.m
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "PuzzleMenuViewController.h"
#import "PuzzleViewController.h"

@interface PuzzleMenuViewController ()

@end

@implementation PuzzleMenuViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender
{
    PuzzleViewController *puzzleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Puzzle"];
    [self presentModalViewController:puzzleViewController animated:YES];
}
@end
