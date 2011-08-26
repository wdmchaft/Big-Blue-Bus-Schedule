//
//  CustomerServiceViewController.h
//  BBB
//
//  Created by Jie Zhao on 5/22/11.
//  Copyright 2011 Zeiga. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerServiceViewController : UIViewController {
    IBOutlet UITextView *customerTextView;
    IBOutlet UITextView *adminInfoTextView;
    IBOutlet UITextView *phoneTextView;
}

@property (nonatomic, retain) UITextView *customerTextView;
@property (nonatomic, retain) UITextView *adminInfoTextView;
@property (nonatomic, retain) UITextView *phoneTextView;
@end
