//
//  helper.h
//  noteApp
//
//  Created by user42 on 2017/4/10.
//  Copyright © 2017年 user42. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;
@interface helper : NSObject
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
+(helper*) sharedInstance;
@end
