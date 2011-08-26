//
//  LineTableViewController.h
//  BBB
//
//  Created by Jie Zhao on 5/17/11.
//  Copyright 2011 Zeiga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewController.h"

@protocol MainTableDelegate;


@interface LineTableViewController : UITableViewController {
    NSMutableArray* arrayLines;
}

@property (nonatomic, retain) NSMutableArray *arrayLines;
@property (nonatomic, assign) id<MainTableDelegate> delegate;

@end
