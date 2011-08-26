

#import <UIKit/UIKit.h>
#import "MoreInfoTableViewController.h"

@class MyTableViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
	UINavigationController	*navSearch;
    UINavigationController  *navMore;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navSearch;
@property (nonatomic, retain) IBOutlet UINavigationController *navMore;

@end
