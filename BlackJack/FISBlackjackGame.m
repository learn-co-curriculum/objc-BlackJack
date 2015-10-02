//  FISBlackjackGame.m

#import "FISBlackjackGame.h"
#import "FISCard.h"

@implementation FISBlackjackGame

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _deck = [[FISCardDeck alloc] init];
        _house = [[FISBlackjackPlayer alloc] initWithName:@"House"];
        _player = [[FISBlackjackPlayer alloc] initWithName:@"Player"];
    }
    
    return self;
}

- (void)playBlackjack {
    [self.deck resetDeck];
    [self.house newGame];
    [self.player newGame];
    
    [self newDeal];
    
    for (NSUInteger i = 0; i < 3; i++) {
        [self playerTurn];
        if (self.player.busted) {
            break;
        }
        
        [self houseTurn];
        if (self.house.busted) {
            break;
        }
    }
    
    BOOL houseWins = [self houseWins];
    [self incrementWinsAndLossesForHouseWins:houseWins];
    
    NSLog(@"%@", self.player);
    NSLog(@"%@", self.house);
}

- (void)newDeal {
    for (NSUInteger i = 0; i < 2; i++) {
        [self dealCardToPlayer];
        [self dealCardToHouse];
    }
}

- (void)dealCardToPlayer {
    FISCard *card = [self.deck drawNextCard];
    [self.player acceptCard:card];
}

- (void)dealCardToHouse {
    FISCard *card = [self.deck drawNextCard];
    [self.house acceptCard:card];
}

- (void)playerTurn {
    BOOL playerMayHit = !self.player.busted && !self.player.stayed;
    
    BOOL playerWillHit = NO;
    if (playerMayHit) {
        playerWillHit = [self.player decideToHit];
    }
    
    if (playerWillHit) {
        [self dealCardToPlayer];
    }
}

- (void)houseTurn {
    BOOL houseMayHit = !self.house.busted && !self.house.stayed;
    
    BOOL houseWillHit = NO;
    if (houseMayHit) {
        houseWillHit = [self.house decideToHit];
    }
    
    if (houseWillHit) {
        [self dealCardToHouse];
    }
}

- (BOOL)houseWins {
    if (self.house.blackjack && self.player.blackjack) {
        return NO; // this is actually a 'push'
    }
    
    if (self.house.busted) {
        return NO;
    }
    
    if (self.player.busted) {
        return YES;
    }
    
    if (self.player.handscore > self.house.handscore) {
        return NO;
    }
    
    return YES;
}

- (void)incrementWinsAndLossesForHouseWins:(BOOL)houseWins {
    if (houseWins) {
        self.house.wins++;
        self.player.losses++;
        NSLog(@"House wins!");
    } else {
        self.house.losses++;
        self.player.wins++;
        NSLog(@"Player wins!");
    }
}

@end

