//
//  NoteViewController.h
//  noteApp
//
//  Created by user42 on 2017/4/10.
//  Copyright © 2017年 user42. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
@protocol NoteViewControllerDelegate
-(void)updateNote:(Note *)note;
@end
@interface NoteViewController : UIViewController
@property (nonatomic,weak) id<NoteViewControllerDelegate> delegate;
@property (nonatomic) Note *currentNote;
@end
