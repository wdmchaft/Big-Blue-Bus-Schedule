//
//  TimeTableViewController.m
//  BBB
//
//  Created by Jie Zhao on 5/12/11.
//  Copyright 2011 Zeiga. All rights reserved.
//

#import "TimeTableViewController.h"
#import "WebViewController.h"
#import <sqlite3.h>

static int MyStringCallback(void *context, int count, char **values, char **columns)
{
    NSMutableArray *lines = (NSMutableArray *)context;
    for (int i=0; i < count; i++) {
        const char *nameCString = values[i];
        [lines addObject:[NSString stringWithUTF8String:nameCString]];
    }
    return SQLITE_OK;
}

@implementation TimeTableViewController

@synthesize stringStopId, stringDay, stringLine, arrayTimes, closestTime, arrayDiff;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [arrayTimes release];
    [arrayDiff release];
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

-(void)loadTimesFromDatabase {
    NSString *query = [NSString stringWithFormat:@"SELECT distinct arrive_time FROM stop_time_table where stop_id=%@ order by stoptime_id asc",self.stringStopId];
    [self loadItemsFromDatabaseByQuery:query withArray:arrayTimes];
}

-(NSString*) findDiffTime:(NSString *)test {
    NSArray *parts = [[test substringToIndex:([test length] - 2)] componentsSeparatedByString:@":"];
    NSString *ampm_string = [test substringFromIndex:([test length] - 2)];
    BOOL isPM = ([ampm_string caseInsensitiveCompare:@"pm"] == NSOrderedSame)? YES : NO;
    int hour_part = [[parts objectAtIndex:0] intValue];
    
    if ((isPM && hour_part !=12) || (!isPM && hour_part == 12))
        hour_part = hour_part + 12;

    int minute_part = [[parts objectAtIndex:1] intValue];
    
    NSDate * today = [NSDate date];
    NSCalendar * cal = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents * current = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:today];
    
    BOOL searchToday = FALSE;
    int dayOfWeek = [current weekday];
    if (dayOfWeek == 1 && [self.stringDay isEqualToString:@"Sunday/Holiday"])
        searchToday = TRUE;
    if (dayOfWeek == 7 && [self.stringDay isEqualToString:@"Saturday"])
        searchToday = TRUE;
    if (dayOfWeek >= 2 && dayOfWeek <= 6 && [self.stringDay isEqualToString:@"Weekdays"])
        searchToday = TRUE;
    if (!searchToday)
        return @"";
    
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    [components setYear:[current year]];
    [components setMonth:[current month]];
    [components setDay:[current day]];
    [components setHour:hour_part];
    [components setMinute:minute_part];
    NSDate *date = [cal dateFromComponents:components];
    
    double timeInterval = [date timeIntervalSinceDate:today];
    int minuteInterval = timeInterval/60;
    int hourInterval = minuteInterval/60;
        
    if (timeInterval < 0)
        return @"";
    else
    {
        if (hourInterval == 0)
            return [NSString stringWithFormat:@"%d min", minuteInterval];
        else
            return [NSString stringWithFormat:@"%d hour and %d min", hourInterval, minuteInterval-60*hourInterval];
    }
}


-(IBAction) viewPdfAction:(id)sender {
    WebViewController *webViewController = [[WebViewController alloc] init];
    
    NSMutableString *stringURL = [NSMutableString stringWithFormat:@"http://www.bigbluebus.com/busroutes/pdf/"];
    if ([self.stringLine isEqualToString:@"Super 12"])
        [stringURL appendString:@"0weekdays.pdf"];
    else if ([self.stringLine isEqualToString:@"Rapid 3"])
        [stringURL appendString:@"33weekdays.pdf"];
    else if ([self.stringLine isEqualToString:@"Rapid 7"])
        [stringURL appendString:@"77weekdays.pdf"];
    else 
    {
        [stringURL appendString:self.stringLine];
        if ([self.stringDay isEqualToString:@"Weekdays"])
            [stringURL appendString:@"weekdays.pdf"];
        else if ([self.stringDay isEqualToString:@"Saturday"])
            [stringURL appendString:@"saturday.pdf"];
        else 
            [stringURL appendString:@"sunday.pdf"];        
    }
    
    webViewController.stringURL = stringURL;
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}


- (void)viewDidLoad
{
    self.arrayTimes = [[NSMutableArray alloc] init];
    self.arrayDiff = [[NSMutableArray alloc] init];
    [self loadTimesFromDatabase];
    
    self.closestTime = -1;
    for (int i = 0; i < [self.arrayTimes count]; ++i) {
        NSString *dateString = [arrayTimes objectAtIndex:i];
        NSString *diffString = [self findDiffTime:dateString];
        [self.arrayDiff addObject:diffString];
        if ([diffString length] != 0 && self.closestTime == -1)
            self.closestTime = i;
    }
    
    //create a bar button
    if ([self.arrayTimes count] != 0)
    {
        UIBarButtonItem *viewPdfButton = [[UIBarButtonItem alloc] initWithTitle:@"View Pdf" style:UIBarButtonItemStyleBordered target:self action:@selector(viewPdfAction:)];
        self.navigationItem.rightBarButtonItem = viewPdfButton;
        [viewPdfButton release];
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

- (void)viewDidAppear:(BOOL)animated
{
    if (self.closestTime != -1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.closestTime inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                                            atScrollPosition:UITableViewScrollPositionTop
                                                animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [arrayTimes count];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.closestTime)
    {
        cell.backgroundColor = [UIColor cyanColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [self.arrayTimes objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.detailTextLabel.text = [self.arrayDiff objectAtIndex:indexPath.row];
    
    
    if (indexPath.row == self.closestTime)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Next bus in %@",cell.detailTextLabel.text];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Arrivals";
}

@end
