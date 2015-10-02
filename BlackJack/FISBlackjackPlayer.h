//  FISBlackjackPlayer.h

#import <Foundation/Foundation.h>
#import "FISCard.h"

@interface FISBlackjackPlayer : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSMutableArray *cardsInHand;
@property (nonatomic, readonly) NSUInteger handscore;

@property (nonatomic) BOOL aceInHand;
@property (nonatomic) BOOL stayed;
@property (nonatomic) BOOL blackjack;
@property (nonatomic) BOOL busted;

@property (nonatomic) NSUInteger wins;
@property (nonatomic) NSUInteger losses;

- (instancetype)init;

- (instancetype)initWithName:(NSString *)name;

- (void)newGame;

- (void)acceptCard:(FISCard *)card;

- (BOOL)decideToHit;

@end
