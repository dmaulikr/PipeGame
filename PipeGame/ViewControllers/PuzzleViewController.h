//
//  PuzzleMenuViewController.h
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "CCViewController.h"

@protocol PuzzleViewControllerDelegate <NSObject>

- (void)pressedBack;

@end


@interface PuzzleViewController : CCViewController <CCStandardTouchDelegate>

@property (assign) NSInteger puzzle;
@property (weak, nonatomic) id <PuzzleViewControllerDelegate> delegate;

- (IBAction)pressedBack:(id)sender;

@end
