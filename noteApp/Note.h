//
//  Note.h
//  noteApp
//
//  Created by user42 on 2017/4/10.
//  Copyright © 2017年 user42. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@import UIKit;
@interface Note : NSManagedObject
@property (nonatomic) NSString *noteID;
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *order;
-(UIImage *)getImage;
-(UIImage *)getSmallImage;
@end
