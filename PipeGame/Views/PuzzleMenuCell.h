//
//  PuzzleMenuCell.h
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import <UIKit/UIKit.h>

@interface PuzzleMenuCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

- (void)configureWithIndexPath:(NSIndexPath *)indexPath;

@end
