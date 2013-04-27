//
//  PuzzleMenuViewController.m
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "PuzzleMenuViewController.h"
#import "PathUtils.h"
#import "PuzzleMenuCell.h"

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
    
//    [self.collectionView registerClass:[PuzzleMenuCell class] forCellWithReuseIdentifier:@"PuzzleMenuCell"];
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
    PuzzleMenuCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PuzzleMenuCell" forIndexPath:indexPath];
    [cell configureWithIndexPath:indexPath];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PuzzleViewController *puzzleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Puzzle"];
    puzzleViewController.puzzle = indexPath.row;
    puzzleViewController.delegate = self;
    [self presentViewController:puzzleViewController animated:YES completion:^{
        // completion
    }];
}

#pragma mark - PuzzleViewControllerDelegate

- (void)pressedBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        // completion
    }];
}

@end
