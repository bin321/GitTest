//
//  NoteViewController.m
//  noteApp
//
//  Created by user42 on 2017/4/10.
//  Copyright © 2017年 user42. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextView  *textView;
    UIImageView *imageView;
    BOOL isPic;
}
@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self  createBarButtonItem];
    [self createSome];
    [self setKeyboard];
    textView.text = _currentNote.name;
    imageView.image = [_currentNote getImage];
    if( self.presentingViewController ){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemCancel) target:self action:@selector(cancel)];
    }
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    
}
- (void)createSome{
    textView = [UITextView new];
    [self.view addSubview:textView];
    imageView = [UIImageView new];
    [self.view addSubview:imageView];
    UIToolbar *tool = [UIToolbar new];
    [self.view addSubview:tool];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [textView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:20].active = YES;
    [textView.bottomAnchor constraintEqualToAnchor:imageView.topAnchor constant:-20].active = YES;
    [textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
    [textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = YES;
    [textView.heightAnchor constraintEqualToAnchor:imageView.heightAnchor].active = YES;
    //[textView.heightAnchor constraintEqualToConstant:200].active = YES;

    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView.bottomAnchor constraintEqualToAnchor:tool.topAnchor constant:-20].active = YES;
    [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
    [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = YES;

    UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemCamera) target:self action:@selector(camera)];
    NSArray *items = [NSArray arrayWithObject:camera];
    
    tool.items = items;
    
    tool.translatesAutoresizingMaskIntoConstraints = NO;
    [tool.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [tool.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [tool.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;

}
-(void)createBarButtonItem{
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemSave) target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = save;
}
-(void)setKeyboard{
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(keyboardDone)];
    NSArray *items = [NSArray arrayWithObjects:flexible,done, nil];
    UIToolbar *tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    tool.translucent = NO;
    tool.barTintColor = [UIColor lightGrayColor];
    tool.items = items;
    textView.inputAccessoryView = tool;
}
-(void)keyboardDone{
    [textView resignFirstResponder];
}
-(void)save{
    _currentNote.name = textView.text;
    if(isPic){
        _currentNote.imageName = [NSString stringWithFormat:@"%@.jpg",_currentNote.noteID];
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *imagePath = [docPath stringByAppendingPathComponent:_currentNote.imageName];
        NSData *imageData = UIImageJPEGRepresentation(imageView.image, 1);
        [imageData writeToFile:imagePath atomically:YES];
    }
    [self.delegate updateNote:_currentNote];
    
    if(self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)camera{
    UIImagePickerController *imagePC = [UIImagePickerController new];
    imagePC.delegate = self;
    imagePC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePC animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *imgae = info[UIImagePickerControllerOriginalImage];
    imageView.image = imgae;
    isPic = true;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
