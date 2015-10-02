//
//  PlayingCardDeck.m
//  BlackJack
//
//  Created by Al Tyus on 6/9/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import <Expecta.h>
#import "FISPlayingCardDeck.h"
#import "FISPlayingCard.h"

SpecBegin(PlayingCardDeck)

describe(@"PlayingCardDeck", ^{
    
    __block FISPlayingCardDeck *deck;
    beforeAll(^{
        
    });
    
    beforeEach(^{
        deck = [[FISPlayingCardDeck alloc] init];
    });
    
    describe(@"init", ^{
        it(@"Should initialize the cards array with 52 cards", ^{
            expect([deck.cards count]).to.equal(52);
            for(FISPlayingCard *card in deck.cards)
            {
                expect(card).to.beKindOf([FISPlayingCard class]);
            }
        });
        it(@"Should initialize the cards array with 52 unique cards", ^{
            NSCountedSet *countedCards = [NSCountedSet setWithArray:deck.cards];
            
            NSInteger heartsCount = 0;
            NSInteger clubsCount = 0;
            NSInteger spadesCount = 0;
            NSInteger diamondsCount = 0;
            
            for (FISPlayingCard *card in deck.cards)
            {
                expect([countedCards countForObject:card]).to.equal(1);
                
                if ([card.suit isEqualToString:@"♠️"]){spadesCount++;}
                if ([card.suit isEqualToString:@"♥️"]){heartsCount++;}
                if ([card.suit isEqualToString:@"♣️"]){clubsCount++;}
                if ([card.suit isEqualToString:@"♦️"]){diamondsCount++;}
                
            }
            expect(heartsCount).to.equal(13);
            expect(clubsCount).to.equal(13);
            expect(spadesCount).to.equal(13);
            expect(diamondsCount).to.equal(13);
        });
    });
});


SpecEnd