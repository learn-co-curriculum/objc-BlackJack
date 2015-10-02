//  FISAppDelegate.m

#import "FISAppDelegate.h"
#import "FISBlackjackGame.h"
#import "FISCard.h"
#import "FISCardDeck.h"

@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    FISBlackjackGame *game = [[FISBlackjackGame alloc] init];
    
    [game playBlackjack];

    [game playBlackjack];
    
    [game playBlackjack];
    
    return YES;
}

@end
