//
//  PuzzleMenuCell.m
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "PuzzleMenuCell.h"

@implementation PuzzleMenuCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"configuring: %@, with index path row: %i", self, indexPath.row);
    self.displayLabel.text = [NSString stringWithFormat:@"%i", (indexPath.row + 1)];
}

@end
