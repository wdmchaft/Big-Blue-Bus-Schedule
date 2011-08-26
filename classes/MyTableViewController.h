//
//  MyTableViewController.h
//  BBB
//
//  Created by Jie Zhao on 5/17/11.
//  Copyright 2011 Zeiga. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainTableDelegate
- (void)didReceiveLineSelection:(NSString *)line;
- (void)didReceiveDaySelection:(NSString *)day;
- (void)didReceiveFromSelection:(NSString *)from withUpdate:(NSString *)to;
- (void)didReceiveToSelection:(NSString *)to withUpdate:(NSString *)from;
@end


@interface MyTableViewController : UITableViewController <MainTableDelegate>
{
@private
    UIButton *searchButton;
	
	NSArray *arrayBusRoutes;
    NSArray *arrayBusStops;
    
    NSMutableArray *arrayLines;
    NSArray *arrayDate; //Weekdays, Saturday, Sunday/Holiday
    NSMutableArray *arrayDirection;
    
    NSString *stringLine;
    NSString *stringDay;
    NSString *stringFrom;
    NSString *stringTo;
}

@property (nonatomic, retain) IBOutlet UIButton *searchButton;

@property (nonatomic, retain) NSArray *arrayBusRoutes; 
@property (nonatomic, retain) NSArray *arrayBusStops;
@property (nonatomic, retain) NSArray *arrayDate;
@property (nonatomic, retain) NSMutableArray *arrayLines;
@property (nonatomic, retain) NSMutableArray *arrayDirection;

@property (copy) NSString *stringLine;
@property (copy) NSString *stringFrom;
@property (copy) NSString *stringTo;
@property (copy) NSString *stringDay;

-(IBAction) searchAction:(id)sender;
@end




