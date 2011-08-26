//
//  MyTableViewController.m
//  BBB
//
//  Created by Jie Zhao on 5/17/11.
//  Copyright 2011 Zeiga. All rights reserved.
//

#import "StopsTableViewController.h"
#import "LineTableViewController.h"
#import "DayTableViewController.h"
#import "EndStationTableViewController.h"
#import <sqlite3.h>

int g_shift_id = 0;

static int MyStringCallback(void *context, int count, char **values, char **columns)
{
    NSMutableArray *arr = (NSMutableArray *)context;
    for (int i=0; i < count; i++) {
        const char *nameCString = values[i];
        [arr addObject:[NSString stringWithUTF8String:nameCString]];
    }
    return SQLITE_OK;
}

static int MyIntCallback(void *context, int count, char **values, char **columns)
{
    for (int i=0; i < count; i++) {
        const char *nameCString = values[i];
        g_shift_id = atoi(nameCString);
    }
    return SQLITE_OK;
}


@implementation MyTableViewController

@synthesize searchButton;
@synthesize arrayBusRoutes, arrayBusStops, arrayLines, arrayDate, arrayDirection;
@synthesize stringDay, stringLine, stringFrom, stringTo;

typedef enum searchSectionIndex 
{
    SECTION_ROUTE = 0,
    SECTION_STOP = 1,
} searchSection;

typedef enum routePartIndex 
{
    BBB_Line = 0,
    BBB_Date = 1,
} SearchPart;

typedef enum stopPartIndex
{
    BBB_From = 0,
    BBB_To = 1,
} StopPart;

-(void)loadItemsFromDatabaseByQuery:(NSString *)query withArray:(NSMutableArray *)array {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"bbb_schedule_db" ofType:@"sqlite"];
    sqlite3 *database = NULL;
    if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
        sqlite3_exec(database, [query UTF8String], MyStringCallback, array, NULL);
    }
    sqlite3_close(database);
}

-(void)loadLinesFromDatabase {
    [self loadItemsFromDatabaseByQuery:@"SELECT distinct line_number FROM bus_shift_table order by shift_id asc" withArray:self.arrayLines];
}

- (void)viewDidLoad
{
	self.arrayBusRoutes = [NSArray arrayWithObjects:@"Line:", @"Day:", nil];
    self.arrayBusStops = [NSArray arrayWithObjects:@"From:", @"To", nil];
    self.arrayDate = [NSArray arrayWithObjects:@"Weekdays", @"Saturday", @"Sunday/Holiday", nil];
    self.arrayLines = [[NSMutableArray alloc] init];
    self.arrayDirection = [[NSMutableArray alloc] init];
    [self loadLinesFromDatabase];
    
    self.tableView.scrollEnabled = NO;
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = homeButton;
    [homeButton release];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.stringLine = [[NSUserDefaults standardUserDefaults] stringForKey:@"busLine"];
    self.stringLine = ([self.stringLine length] == 0)? @"1":self.stringLine;
    self.stringDay = [[NSUserDefaults standardUserDefaults] stringForKey:@"busDate"];
    self.stringDay = ([self.stringDay length] == 0)? @"Weekdays":self.stringDay;
    self.stringFrom = [[NSUserDefaults standardUserDefaults] stringForKey:@"busFrom"];
    self.stringFrom = ([self.stringFrom length] == 0)? @"Venice":self.stringFrom;
    self.stringTo = [[NSUserDefaults standardUserDefaults] stringForKey:@"busTo"];
    self.stringTo = ([self.stringTo length] == 0)? @"UCLA":self.stringTo;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setValue:self.stringLine forKey:@"busLine"];
    [[NSUserDefaults standardUserDefaults] setValue:self.stringDay forKey:@"busDate"];
    [[NSUserDefaults standardUserDefaults] setValue:self.stringFrom forKey:@"busFrom"];
    [[NSUserDefaults standardUserDefaults] setValue:self.stringTo forKey:@"busTo"];
}

- (void)dealloc
{	
	[arrayBusRoutes release];
    [arrayBusStops release];
    [arrayLines release];
    [arrayDate release];
    [arrayDirection release];
    [searchButton release];
	
	[super dealloc];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_ROUTE)
        return [self.arrayBusRoutes count];
    else if (section == SECTION_STOP)
        return [self.arrayBusStops count];
    else
        return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SECTION_ROUTE)
        return @"Bus Routes";
    else if (section == SECTION_STOP)
        return @"Direction";
    else
        return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   
    if (indexPath.section == SECTION_ROUTE)
    {
        if (indexPath.row == BBB_Line)
        {
            LineTableViewController *lineController = [[LineTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            lineController.arrayLines = self.arrayLines;
            lineController.delegate = self;
            lineController.title = @"Line";
            [self.navigationController pushViewController:lineController animated:YES];
            [lineController release];
        }
        else if (indexPath.row == BBB_Date)
        {
            DayTableViewController *dayController = [[DayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            dayController.arrayDay = self.arrayDate;
            dayController.delegate = self;
            dayController.title = @"Day";
            [self.navigationController pushViewController:dayController animated:YES];
            [dayController release];
        }
        else
            return;
    }
    else if (indexPath.section == SECTION_STOP)
    {
        UITableViewCell *cell_line = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_Line inSection:0]];
        self.stringLine = cell_line.detailTextLabel.text;
        //get the current arrayDirection
        [self.arrayDirection removeAllObjects];
        NSString *wherePart = [NSString stringWithFormat:@" where line_number='%@'",self.stringLine];
        NSString *query = [NSString stringWithFormat:@"SELECT distinct line_from FROM bus_shift_table%@ order by shift_id asc",wherePart];
        [self loadItemsFromDatabaseByQuery:query withArray:self.arrayDirection];
        EndStationTableViewController *endController = [[EndStationTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        endController.arrayEndStations = self.arrayDirection;
        endController.delegate = self;
        endController.isStartStation = (indexPath.row == BBB_From);
        [self.navigationController pushViewController:endController animated:YES];
        [endController release];
    }
}

                           
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"CustomCellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID] autorelease];
	}
    
    if (indexPath.section == SECTION_ROUTE)
    {
        cell.textLabel.text = [self.arrayBusRoutes objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        switch (indexPath.row) {
            case BBB_Line:
                cell.detailTextLabel.text = self.stringLine;
                UIImage *icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bus_small" ofType:@"png"]];
                cell.imageView.image = icon;
                break;
            case BBB_Date:
                cell.detailTextLabel.text= self.stringDay;
                UIImage *icon_date = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"date_small" ofType:@"png"]];
                cell.imageView.image = icon_date;
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == SECTION_STOP)
    {
        cell.textLabel.text = [self.arrayBusStops objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case BBB_From:
                cell.detailTextLabel.text = self.stringFrom;
                break;
            case BBB_To:
                cell.detailTextLabel.text= self.stringTo;
                break;
            default:
                break;
        }
    }
           
   	return cell;
}

// custom view for footer. will be adjusted to default or specified footer height
// Notice: this will work only for one section within the table view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1)
    {
        UIView *footerView  = [[[UIView alloc] init] autorelease];
        
        //we would like to show a gloosy red button, so get the image first
        UIImage *image = [[UIImage imageNamed:@"button_green.png"]
                          stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        
        //create the button
        self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.searchButton setBackgroundImage:image forState:UIControlStateNormal];
        
        //the button should be as big as a table view cell
        [self.searchButton setFrame:CGRectMake(10, 20, image.size.width, image.size.height)];
        
        //set title, font size and font color
        [self.searchButton setTitle:@"Find Schedule" forState:UIControlStateNormal];
        [self.searchButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //set action of the button
        [self.searchButton addTarget:self action:@selector(searchAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        //add the button to the view
        [footerView addSubview:self.searchButton];        
        // Return the footerView
        return footerView;
    }
    else
        return nil;
    
}

// specify the height of your footer section
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 200;
}

-(IBAction) searchAction:(id)sender {
    UITableViewCell *cell_line = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_Line inSection:0]];
    UITableViewCell *cell_date = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_Date inSection:0]];
    UITableViewCell *cell_from = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_From inSection:1]];
    UITableViewCell *cell_to = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_To inSection:1]];
    self.stringLine = cell_line.detailTextLabel.text;
    self.stringDay = cell_date.detailTextLabel.text;
    self.stringFrom = cell_from.detailTextLabel.text;
    self.stringTo = cell_to.detailTextLabel.text;
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_Line inSection:0] animated:YES];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_Date inSection:0] animated:YES]; 
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_From inSection:1] animated:YES]; 
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_To inSection:1] animated:YES]; 
    

    g_shift_id = 0;
    NSString *query = [NSString stringWithFormat:@"SELECT shift_id FROM bus_shift_table where line_number='%@' and line_from='%@' and operate_date='%@'",self.stringLine,self.stringFrom,self.stringDay];
        
    NSString *file = [[NSBundle mainBundle] pathForResource:@"bbb_schedule_db" ofType:@"sqlite"];
    sqlite3 *database = NULL;
    if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
        sqlite3_exec(database, [query UTF8String], MyIntCallback, NULL, NULL);
    }
    sqlite3_close(database);
    
    StopsTableViewController *stopsTableController = [[StopsTableViewController alloc] init];
    stopsTableController.title = [NSString stringWithFormat:@"Line: %@",self.stringLine];
    stopsTableController.stringShiftId = [NSString stringWithFormat:@"%d",g_shift_id];
    stopsTableController.stringDay = self.stringDay;
    stopsTableController.stringLine = self.stringLine;
    [self.navigationController pushViewController:stopsTableController animated:YES];
    [stopsTableController release];
}

- (void)didReceiveLineSelection:(NSString *)line{
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_Line inSection:0]];
    cell.detailTextLabel.text = line;
    self.stringLine = line;
    
    //invalidate the 'from' and 'to' selection
    UITableViewCell *cell_from = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_From inSection:1]];
    UITableViewCell *cell_to = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_To inSection:1]];
    
    [self.arrayDirection removeAllObjects];
    NSString *wherePart = [NSString stringWithFormat:@" where line_number='%@'",self.stringLine];
    NSString *query = [NSString stringWithFormat:@"SELECT distinct line_from FROM bus_shift_table%@ order by shift_id asc",wherePart];
    [self loadItemsFromDatabaseByQuery:query withArray:self.arrayDirection];
    self.stringFrom = [self.arrayDirection objectAtIndex:0];
    self.stringTo = [self.arrayDirection objectAtIndex:1];
    cell_from.detailTextLabel.text = self.stringFrom;
    cell_to.detailTextLabel.text = self.stringTo;
}
- (void)didReceiveDaySelection:(NSString *)day{
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_Date inSection:0]];
    cell.detailTextLabel.text = day;
    self.stringDay = day;
}

- (void)didReceiveFromSelection:(NSString *)from withUpdate:(NSString *)to;
{
    UITableViewCell *cell_from = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_From inSection:1]];
    cell_from.detailTextLabel.text = from;
    self.stringFrom = from;
    
    //update the other part: 'to'
    UITableViewCell *cell_to = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_To inSection:1]];
    cell_to.detailTextLabel.text = to;
}

- (void)didReceiveToSelection:(NSString *)to  withUpdate:(NSString *)from;
{
    UITableViewCell *cell_to = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_To inSection:1]];
    cell_to.detailTextLabel.text = to;
    self.stringFrom = to; 
    
    //update the other part: 'from'
    UITableViewCell *cell_from = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BBB_From inSection:1]];
    cell_from.detailTextLabel.text = from;
}

@end

