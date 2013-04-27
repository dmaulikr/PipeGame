//
//  PuzzleMenuViewController.m
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "PuzzleMenuViewController.h"
#import "PuzzleViewController.h"
#import "PathUtils.h"

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
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [PathUtils tileMapNames].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PuzzleViewController *puzzleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Puzzle"];
    puzzleViewController.puzzle = indexPath.row;
    [self presentModalViewController:puzzleViewController animated:YES];
}

@end
