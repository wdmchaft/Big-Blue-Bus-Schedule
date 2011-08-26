

#import "AppDelegate.h"
#import "MyTableViewController.h"


@implementation AppDelegate;

@synthesize window, navSearch, navMore;

- (void)dealloc
{
    [navSearch release];
    [navMore release];
    [tabBarController release];
	[window release];
	
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // create window and set up table view controller
    tabBarController = [[UITabBarController alloc] init];
    
    UITabBarItem *itemSearch = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    navSearch.tabBarItem = itemSearch;
    [itemSearch release];
    
    UITabBarItem *itemMore = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
    navMore.tabBarItem = itemMore;
    [itemMore release];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:navSearch, navMore, nil];
    
    MoreInfoTableViewController *moreInfoController = [[MoreInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [navMore pushViewController:moreInfoController animated:NO];

    [moreInfoController release];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}

@end
