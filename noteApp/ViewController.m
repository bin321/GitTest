//
//  ViewController.m
//  noteApp
//
//  Created by user42 on 2017/4/10.
//  Copyright © 2017年 user42. All rights reserved.
//

#import "ViewController.h"
#import "helper.h"
#import "Note.h"
#import "NoteViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NoteViewControllerDelegate>
{
    UITableView *myTableView;
    NSMutableArray *data;
}
@end

@implementation ViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self queryFromCoreData];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBarButtonItem];
    [self createTableView];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}
-(void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    myTableView = [UITableView new];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    myTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [myTableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:0].active = YES;
    [myTableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:0].active = YES;
    [myTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [myTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
}
-(void)createBarButtonItem{
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(add)];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemEdit) target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = add;
    self.navigationItem.leftBarButtonItem = edit;
}
#pragma mark barbuttonItem action
-(void)add{
    double order = 0;
    if(data.count > 0){
        Note *lastNote = data[0];
        order = [lastNote.order doubleValue];
        order ++;
    }
    helper *helpers = [helper sharedInstance];
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:helpers.managedObjectContext];
    note.name = @"new note";
    note.order = @(order);
    [data insertObject:note atIndex:0];
    [self saveToCoreData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [myTableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)edit{
    
}
#pragma mark NoteVC
-(void)updateNote:(Note *)note{
    [self saveToCoreData];
    NSUInteger index = [data indexOfObject:note];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}
#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Note"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.showsReorderControl = YES;
    Note *note = data[indexPath.row];
    cell.textLabel.text = [note.name stringByAppendingFormat:@":%f",[note.order doubleValue]];
    cell.imageView.image = [note getSmallImage];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Note *note = data[indexPath.row];
    NoteViewController *noteVC = [NoteViewController new];
    noteVC.currentNote = note;
    noteVC.delegate = self;
    if(!true){
        [self.navigationController pushViewController:noteVC animated:YES];
    }else{
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:noteVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [myTableView setEditing:editing animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        Note *note = data[indexPath.row];
        [data removeObjectAtIndex:indexPath.row];
        helper *helpers = [helper sharedInstance];
        [helpers.managedObjectContext deleteObject:note];
        [myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [self saveToCoreData];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    if(sourceIndexPath.row != destinationIndexPath.row){
        Note *note = data[sourceIndexPath.row];
        float order;
        
        if(sourceIndexPath.row > destinationIndexPath.row){
            Note *desNoteDown = data[destinationIndexPath.row];
            if(destinationIndexPath.row == 0){
                order = [desNoteDown.order floatValue] + 1.0;
            }else{
                Note *desNoteUp = data[destinationIndexPath.row - 1];
                order = ([desNoteDown.order floatValue] + [desNoteUp.order floatValue]) / 2;
            }
        }else{
            Note *desNoteUp = data[destinationIndexPath.row];
            if(destinationIndexPath.row == data.count - 1){
                order = [desNoteUp.order floatValue] - 1.0;
            }else{
                Note *desNoteDown = data[destinationIndexPath.row + 1];
                order = ([desNoteDown.order floatValue] + [desNoteUp.order floatValue]) / 2;
            }
        }
        note.order = @(order);
        
        [data removeObject:note];
        [data insertObject:note atIndex:destinationIndexPath.row];
        [self saveToCoreData];
        
        tableView.visibleCells[sourceIndexPath.row].textLabel.text = [note.name stringByAppendingFormat:@":%f",[note.order doubleValue]];
    }
    
    //NSLog(@"source:%ld",(long)sourceIndexPath.row);
    //NSLog(@"destination:%ld",(long)destinationIndexPath.row);
}
#pragma mark Core
-(void)saveToCoreData{
    helper *helpers = [helper sharedInstance];
    NSError *error = nil;
    [helpers.managedObjectContext save:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
}
-(void)queryFromCoreData{
    helper *helpers = [helper sharedInstance];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    NSError *error = nil;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"order" ascending:NO];
    NSArray *sorts = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sorts];
    NSArray *results = [helpers.managedObjectContext executeFetchRequest:request error:&error];
    if ( error ){
        NSLog(@"error %@",error);
        data = [NSMutableArray array];
    }else{
        //組成data
        data = [NSMutableArray arrayWithArray:results];
    }
}
@end
