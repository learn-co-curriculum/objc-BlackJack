//
//  BlackjackGameTests.m
//  BlackJack
//
//  Created by Al Tyus on 6/11/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import <Expecta.h>
#import "FISBlackjackGame.h"
#import "FISPlayingCard.h"


SpecBegin(FISBlackjackGame)

__block FISBlackjackGame *game;

describe(@"FISBlackjackGame", ^{
    
    beforeAll(^{
        
    });
    
    beforeEach(^{
        game = [[FISBlackjackGame alloc] init];
    });
    
    describe(@"init", ^{
        it(@"should initialize a game with a deck handscore and hand", ^{
            expect(game).to.beKindOf([FISBlackjackGame class]);
            
            expect(game.playingCardDeck).toNot.beNil();
            expect([game.playingCardDeck.cards count]).to.equal(52);
            
            NSPredicate *heartsPredicate = [NSPredicate predicateWithFormat:@"self.suit == '♥️'"];
            NSArray *hearts = [game.playingCardDeck.cards filteredArrayUsingPredicate:heartsPredicate];
            expect([hearts count]).to.equal(13);
            
            NSPredicate *clubsPredicate = [NSPredicate predicateWithFormat:@"self.suit == '♣️'"];
            NSArray *clubs = [game.playingCardDeck.cards filteredArrayUsingPredicate:clubsPredicate];
            expect([clubs count]).to.equal(13);
            
            NSPredicate *spadesPredicate = [NSPredicate predicateWithFormat:@"self.suit == '♠️'"];
            NSArray *spades = [game.playingCardDeck.cards filteredArrayUsingPredicate:spadesPredicate];
            expect([spades count]).to.equal(13);
            
            NSPredicate *diamondsPredicate = [NSPredicate predicateWithFormat:@"self.suit == '♦️'"];
            NSArray *diamonds = [game.playingCardDeck.cards filteredArrayUsingPredicate:diamondsPredicate];
            expect([diamonds count]).to.equal(13);
            
            expect(game.handScore).toNot.beNil();
            expect(game.handScore).to.equal(@0);
            
            expect(game.hand).to.beKindOf([NSMutableArray class]);
            expect([game.hand count]).to.equal(0);
            
        });
    });
    describe(@"deal", ^{
        it(@"should deal two cards", ^{
            [game deal];
            
            expect([game.hand count]).to.equal(2);
            expect(game.hand[0]).to.beKindOf([FISPlayingCard class]);
            expect(game.hand[1]).to.beKindOf([FISPlayingCard class]);
            expect(game.hand[0]).toNot.equal(game.hand[1]);
        });
    });
    describe(@"hit", ^{
        it(@"should add one card to a dealt hand", ^{
            [game deal];
            [game hit];
            NSLog(@"%d", [game.hand count]); 
            expect([game.hand count]).to.equal(3);
        });
        it(@"should not hit if cards are not dealt", ^{
            [game hit];
            
            expect([game.hand count]).to.equal(0);
        });
        it(@"should not hit if hand is busted", ^{
            
            FISPlayingCard *kingHearts = [[FISPlayingCard alloc] initWithSuit:@"♥️" rank:@13];
            FISPlayingCard *kingDiamonds = [[FISPlayingCard alloc] initWithSuit:@"♦️" rank:@13];
            FISPlayingCard *kingClubs = [[FISPlayingCard alloc] initWithSuit:@"♣️" rank:@13];
            
            NSMutableArray *hand =[NSMutableArray arrayWithArray:@[kingClubs, kingDiamonds, kingHearts]];
            game.hand = hand;
            
            [game hit];
            
            expect([game.hand count]).to.equal(3);
            expect(game.hand).to.equal(hand); 
        });
    });
    describe(@"isBusted", ^{
        it(@"should return YES if the handScore is greater than 21", ^{
            FISPlayingCard *kingHearts = [[FISPlayingCard alloc] initWithSuit:@"♥️" rank:@13];
            FISPlayingCard *kingDiamonds = [[FISPlayingCard alloc] initWithSuit:@"♦️" rank:@13];
            FISPlayingCard *kingClubs = [[FISPlayingCard alloc] initWithSuit:@"♣️" rank:@13];
            FISPlayingCard *aceClubs = [[FISPlayingCard alloc] initWithSuit:@"♣️" rank:@1];
            
            game.hand = [NSMutableArray arrayWithArray:@[kingClubs, kingDiamonds, kingHearts]];
            
            
            expect(game.isBusted).to.beTruthy();
            
            game.hand = [NSMutableArray arrayWithArray:@[kingHearts, kingClubs, aceClubs]];
            
            expect(game.isBusted).to.beFalsy();
        });
    });
    describe(@"hand", ^{
        it(@"should have an NSMutableArray property hand", ^{
            expect(game.hand).to.beKindOf([NSMutableArray class]);
        });
    });
    describe(@"handScore", ^{
        __block FISPlayingCard *aceClubs;
        __block FISPlayingCard *aceHearts;
        __block FISPlayingCard *aceDiamonds;
        __block FISPlayingCard *aceSpades;
        __block FISPlayingCard *kingHearts;
        __block FISPlayingCard *kingDiamonds;
        
        beforeEach(^{
            aceClubs = [[FISPlayingCard alloc] initWithSuit:@"♣️" rank:@1];
            aceHearts = [[FISPlayingCard alloc] initWithSuit:@"♥️" rank:@1];
            aceDiamonds = [[FISPlayingCard alloc] initWithSuit:@"♦️" rank:@1];
            aceSpades = [[FISPlayingCard alloc] initWithSuit:@"♠️" rank:@1];
            kingHearts = [[FISPlayingCard alloc] initWithSuit:@"♥️" rank:@13];
            kingDiamonds = [[FISPlayingCard alloc] initWithSuit:@"♦️" rank:@13];
        });
        it(@"should implement handScore", ^{
            expect(game).to.respondTo(@selector(handScore)); 
        });
        it(@"should return an NSNumber integer", ^{
            game.hand = [NSMutableArray arrayWithArray:@[aceClubs, aceHearts, aceDiamonds, aceSpades]];
            expect(game.handScore).to.beKindOf([NSNumber class]);
            expect([game.handScore doubleValue] == floorl([game.handScore doubleValue])).to.beTruthy(); //checks that value as a double is an int
        });
        it(@"should use ace as 11 whenever possible, but use ace as 1 if using it as an 11 would make the handscore greater than 21", ^{
        
            game.hand = [NSMutableArray arrayWithArray:@[aceClubs, aceHearts, aceDiamonds, aceSpades]];
            expect(game.handScore).to.equal(@14); //11 + 1 + 1 + 1
            
            game.hand = [NSMutableArray arrayWithArray:@[aceSpades, kingHearts]];
            
            expect(game.handScore).to.equal(@21); //11 + 10
            
            game.hand = [NSMutableArray arrayWithArray:@[aceSpades, kingHearts, aceHearts]];
            
            expect(game.handScore).to.equal(12); //1 + 10 + 1
            expect(game.isBusted).to.beFalsy();
            
            game.hand = [NSMutableArray arrayWithArray:@[aceSpades, kingHearts, aceHearts, kingDiamonds]];
            
            expect(game.handScore).to.equal(@22); //1+10+1+10
            expect(game.isBusted).to.beTruthy();
            
        });
    });
});


SpecEnd