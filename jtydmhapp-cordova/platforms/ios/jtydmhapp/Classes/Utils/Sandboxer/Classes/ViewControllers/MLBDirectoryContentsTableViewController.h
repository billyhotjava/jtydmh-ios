//
//  MLBDirectoryContentsTableViewController.h
//  Example
//
//  Created by meilbn on 18/07/2017.
//  Copyright © 2017 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBFileInfo.h"

@interface MLBDirectoryContentsTableViewController : UIViewController

@property (nonatomic, assign, getter=isHomeDirectory) BOOL homeDirectory;
@property (nonatomic, strong) MLBFileInfo *fileInfo;

@end
