//
//  StopsTableViewController.m
//  BBB
//
//  Created by Jie Zhao on 5/11/11.
//  Copyright 2011 Zeiga. All rights reserved.
//

#import "StopsTableViewController.h"
#import "TimeTableViewController.h"
#import "StopsListTableViewController.h"
#import <sqlite3.h>

int g_stop_id = 0;

static int MyStringCallback(void *context, int count, char **values, char **columns)
{
    NSMutableArray *lines = (NSMutableArray *)context;
    for (int i=0; i < count; i++) {
        const char *nameCString = values[i];
        [lines addObject:[NSString stringWithUTF8String:nameCString]];
    }
    return SQLITE_OK;
}

static int MyIntCallback(void *context, int count, char **values, char **columns)
{
    for (int i=0; i < count; i++) {
        const char *nameCString = values[i];
        g_stop_id = atoi(nameCString);
    }
    return SQLITE_OK;
}

@implementation StopsTableViewController


@synthesize stringShiftId, arrayStops, stringLine, stringDay;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [arrayStops release];
    [super dealloc];
}


-(void)loadItemsFromDatabaseByQuery:(NSString *)query withArray:(NSMutableArray *)array {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"bbb_schedule_db" ofType:@"sqlite"];
    sqlite3 *database = NULL;
    if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
        sqlite3_exec(database, [query UTF8String], MyStringCallback, array, NULL);
    }
    sqlite3_close(database);
}

-(void)loadStopsFromDatabase {
    NSString *query = [NSString stringWithFormat:@"SELECT distinct stop_name FROM shift_stop_table where shift_id=%@ order by stop_id asc",self.stringShiftId];
    [self loadItemsFromDatabaseByQuery:query withArray:arrayStops];
}

-(IBAction) moreAction:(id)sender
{
    StopsListTableViewController *stopsListController = [[StopsListTableViewController alloc] init];
    stopsListController.stringShiftId = self.stringShiftId;
    [self.navigationController pushViewController:stopsListController animated:YES];
    [stopsListController release];
}

- (void)viewDidLoad
{
    self.arrayStops = [[NSMutableArray alloc] init];
    [self loadStopsFromDatabase];

    if ([self.arrayStops count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Services for this bus line are not available on Saturdays/Sundays." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithTitle:@"All Stops" style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction:)];
        self.navigationItem.rightBarButtonItem = moreButton;
        [moreButton release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [self.arrayStops objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [arrayStops objectAtIndex:indexPath.row];
    NSString *query = [NSString stringWithFormat:@"SELECT distinct stop_id FROM shift_stop_table where shift_id=%@ and stop_name='%@'",self.stringShiftId, selected];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"bbb_schedule_db" ofType:@"sqlite"];
    sqlite3 *database = NULL;
    if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
        sqlite3_exec(database, [query UTF8String], MyIntCallback, NULL, NULL);
    }
    sqlite3_close(database);
    
    TimeTableViewController *timeTableController = [[TimeTableViewController alloc] init];
    timeTableController.stringStopId = [NSString stringWithFormat:@"%d",g_stop_id];
    timeTableController.stringDay = self.stringDay;
    timeTableController.stringLine = self.stringLine;
    [self.navigationController pushViewController:timeTableController animated:YES];
    timeTableController.title = @"Schedule";
    [timeTableController release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Time Point";
}

@end
