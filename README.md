# BlackJack Console

## Objectives
 
1. Reuse (copy) code from another project into a current project.
2. Use a set of custom classes to create a rudimentary application program.

#### Advanced

1. Extend the functionality of an existing codebase to handle a more complex approach to the application.

## Introduction

[Blackjack](https://en.wikipedia.org/wiki/Blackjack), also known as "twenty-one", is a casino card game in which a player attempts to build a hand that is closer to a score of 21 than the house (or dealer's) hand without going over a total of 21 (or "busting"). The Ace's base value is one (1), but can be used as a value of eleven (11) if doing so does not bust a hand. Players are initially dealt two cards and choose to be dealt additional cards (to "hit") or to hold their hand until the end of the round (to "stay").

In the this exercise, we're going to set up a player class that has knowledge of how to play Blackjack: score its own hand and decide whether to hit or stay. We'll then create class that can execute a Blackjack game between the house and a single player.

## Instructions

Fork and clone this lab.

### I. Set Up The Class Files

##### A. Reuse `FISCard` and `FISCardDeck` from OOP-Cards-Model

This lab reuses the `FISCard` and `FISCardDeck` classes created in the OOP-Cards-Model lab. Find a way to bring your code for those classes into your `BlackJack` project. While you can feasibly copy & paste your code between projects using the clipboard, think about how you could use the `pwd` ("print working director"), `cp` ("copy"), and `mv` ("move") bash commands to duplicate the `FISCard.h`, `FISCard.m`, `FISCardDeck.h`, and `FISCardDeck.m` files right in the terminal. The exact command will vary based upon the relative path between your lab folders on your own machine, so we can't give you exact directions for how to do this. Their most appropriate destination within this lab is the `objc-blackjack/BlackJack` directory (which should also contain the `FISAppDelegate` class files). If you use bash to copy the files, you'll need to add them to your Xcode project once they're in the correct directory by selecting File --> Add Files to "BlackJack" from the taskbar. Verify that the file paths point into the Blackjack repository and not the OOP-Cards-Model repository.

**Note:** *If using the terminal intimidates you, simply create the* `FISCard` *and* `FISCardDeck` *class files in Xcode as normal and use the clipboard to copy & paste your code.*

##### B. Create Additional Class Files

Before we can run the testing suite we need to set up two new classes: `FISBlackjackGame` and `FISBlackjackPlayer`. Create these class files now.

1. In `FISBlackjackGame.h`, import `FISBlackjackPlayer.h` and `FISCardDeck.h`. Then,
  * Create three public properties:
     * a `FISCardDeck` called `deck`,
     * a `FISBlackjackPlayer` called `house`, and
     * a `FISBlackjackPlayer` called `player`.  
  * And declare the following public methods:
     * `playBlackjack` which provides no return,
     * `newDeal` which provides no return,
     * `dealCardToPlayer` which provides no return,
     * `dealCardToHouse` which provides no return,
     * `playerTurn` which provides no return,
     * `houseTurn` which provides no return,
     * `houseWins`, which returns a `BOOL`,
     * `incrementWinsAndLossesForHouseWins:` which takes one argument, a `BOOL` called `houseWins`, and provides no return.

2. In `FISBlackjackGame.m`, define the methods to empty implementations, except `houseWins` which should `return NO;`.

3. In `FISBlackjackPlayer.h`, import `FISCard.h`. Then,
  * Create three `readonly` properties:
     * an `NSString` called `name`,
     * an `NSMutableArray` called `cardsInHand`, and
     * an `NSUInteger` called `handscore`;
  * Create six more fully-public properties (in order to be testable):
     * a `BOOL` called `aceInHand`,
     * a `BOOL` called `stayed`,
     * a `BOOL` called `blackjack`,
     * a `BOOL` called `busted`,
     * an `NSUInteger` called `wins`, and
     * an `NSUInteger` called `losses`;
  * Declare the following methods:
     * a designated initializer which takes one argument, an `NSString` for `name`,
     * `newGame` which provides no return,
     * `acceptCard:` which takes one argument, a `FISCard` called `card`, and provides no return, and
     * `decideToHit` which returns `BOOL`.

4. In `FIBlackjackPlayer.m`, redeclare the three `readonly` properties `name`, `cardsInHand`, and `handscore` as privately `readwrite`. Define the designated initializer to `return [super init];`, the `void` methods `newGame` and `acceptCard:` to empty implementations, and `decideToHit` to `return NO;`.

5. At this point, the test suite should successfully build. Go ahead and run the tests to check for initial failures. If you have any errors, double-check your set up. If you successfully copied your implementations of `FISCard` and `FISCardDeck`, then all of the tests on those classes should already succeed.

### II. Implement `FISBlackjackPlayer`

Before we can write the logic for the blackjack game, we need to tell the players how to play.

1. Let's start at the beginning of the class's lifecycle by filling out the designated initializer. It should:
  * set the `_name` ivar to the `name` argument,
  * initialize the `_cardsInHand` ivar to an empty mutable array,
  * set the integer ivars `_handscore`, `_wins`, and `_losses` to zero, and
  * set the boolean ivars `_aceInHand`, `_stayed`, `_blackjack`, and `_busted` to `NO`.

2. Override the default initializer (`init`) to called the designated initializer with an empty string submitted as the `name` argument.

3. Next, let's teach our player class how to accept a card and interpret the current `handscore`. Start by declaring a helper method called `scoreHand` that provides no return. Leave it empty for now. Within `acceptCard:`, add the `card` argument to the `cardsInHand` array, then call the `scoreHand` method.

4. Within the `scoreHand` helper method, total the `cardValue` property of all the cards in the `cardsInHand` array (**Hint:** *You'll need to use a loop*). Set the value of the `handscore` property to the total.

5. Now let's add functionality to detect an Ace (represented in the `FISCard`'s `rank` property as the string `@"A"`) and adjust the score accordingly. Find a way to detect of the `cardsInHand` array contains an Ace and flip the `aceInHand` boolean to `YES` if it does. Then, if the total value of the cards in the hand is eleven (11) or less, add ten (10) points to the score. This, effectively, is teaching the player to use the Ace as a "soft eleven" when doing so will not cause a bust, but teaching it to use the Ace as a "hard one" otherwise.

6. Now we should give the player an ability to detect when its hand is a "blackjack" (two cards with a score of 21) or is "busted" (a score of 22 or higher). Create two private helper methods that evaluate the hand for a blackjack, and evaluate the hand for a bust. Name them whatever you wish. Call them at the very end of the `scoreHand` method after setting the `handscore` property. 
  * The evaluation for a "blackjack" should set the `blackjack` boolean to `YES` if the number of cards in the `cardsInHand` array is exactly `2` and if the `handscore` is exactly `21`.
  * The evaluation for a "bust" should set the `busted` boolean to `YES` if the `handscore` is greater than `21`.  
All of the tests for `acceptCard:` should pass before you move on.

7. Write the implementation for the `decideToHit` method. This is how the player decides whether to accept a new card ("to hit") or stop at its current score until the end of the game ("to stay"). After staying, the player cannot take a new card for the rest of the current game. A simple implementation of the decision making method is to just have the player follow "house rules": which is to say that the house is required to openly declare at what score it will stay—typically either 16 or 17.
  * Choose either 16 or 17 as the maximum score to hit. Use an `if` statement that compares the current `handscore` to the value you've chosen. If the `handscore` is greater than that value, set the `stayed` property to `YES` and `return NO;`, otherwise return `YES`.

8. Write the implementation for the `newGame` which tells the player how to reset for a new game. It should:
  * empty the `cardsInHand` array,
  * set `handscore` to zero, and
  * set the four boolean values (`aceInHand`, `stayed`, `blackjack`, and `busted`) to `NO`.  
  * It should **not** affect the `wins` and `losses` integers.

9. Lastly, override the `description` method to provide a customized printout in the debug console. **Hint:** *This is a great time to use* `NSMutableString`. Because of randomization, the tests are simply looking that this string contains substrings that match the property names, so it is somewhat up to you to decide how to present the information. Remember that you can format line breaks with `\n` and indentations with spaces. Consider the following console output when formatting your string:

```
2015-10-02 15:48:32.953 BlackJack[9872:367674] FISBlackjackPlayer:
  name: Player
  cards: ♠A ♠J
  handscore  : 21
  ace in hand: 1
  stayed     : 1
  blackjack  : 1
  busted     : 0
  wins  : 2
  losses: 0
``` 

Use the `FISAppDelegate`'s `application:didFinishLaunchingWithOptions:` method to create an instance of `FISBlackjackPlayer` with your own name and `NSLog()` its description string. You can initialize an instance of `FISCardDeck` and use its `drawNextCard` method to pass your player a card using its `acceptCard:` method. Remember to use `⌘` `R` to run the scheme instead of the tests.

### II. Implement `FISBlackjackGame`

Now that we've taught our `FISBlackjackPlayer` class how to play Blackjack, let's set up the game. As you may infer from how we set up the class file, it's the game that will be responsible for holding the deck and dealing the cards to the two players `house` and `player` (in Blackjack, all players play individually against the house).

1. Start by overriding `FISBlackjackGame`'s default initializer (`init`). It should
  * initialize the `_deck` ivar to a default instance of `FISCardDeck`,
  * initialize the `_house` ivar to an instance of `FISBlackjackPlayer` with the name `@"House"`, and
  * initialize the `_player` ivar to an instance of `FISBlackjackPlayer` with the name `@"Player"`.  
  **Advanced:** *You may change the name of the player to your own name if you wish, just be sure to edit the test file to expect a string containing your name instead of* `@"Player"` *so that it will still pass.*

2. Next, write the implementations for `dealCardToPlayer` and `dealCardToHouse`. They should use `FISCardDeck`'s `drawNextCard` method to get the next card from the `deck`, and use `FISBlackjackPlayer`'s `acceptCard:` method to pass the card to the respective player.

3. Write the implementation for `newDeal`. This is the first deal of a new game which provides two cards to each player. Remember that cards should be dealt one at a time to all players in a round. (*Can you use a loop with two iterations to avoid repeating your code?*).

4. Now write the implementations for the `playerTurn` and `houseTurn` methods. In blackjack, a player may hit (get dealt a new card) if they have not busted nor stayed, however, they may choose to either hit or stay. (*Can you use the boolean values owned by the player and the house to evaluate their permission to hit? Also, remember that we set up a* `decideToHit` *method on the player class.*)

5. Now write the implementation for the `houseWins` method. This returns a boolean of whether or not the house has won (you may treat a "push", which is when both the player and the house have blackjack hands, as a loss for the house). Keep in mind that if the house has busted, the player wins. If the player has busted, then the house wins. And the player only wins with a score that *exceeds* the house's score (the house wins ties).

6. Write the implementation for `incrementWinsAndLossesForHouseWins:`. Evaluate the argument boolean. If the house has won, then add one to the house's `wins` property and to the player's `losses` property. However, if the house has **not** won, then add one to the house's `losses` property and to the player's `wins` property. Add an `NSLog()` message for each case so you can see the result of the hand in the debug console.

7. At this point, all of the tests should be passing. You've written all the logic for the individual steps of playing Blackjack. Now, put them together inside the `playBlackjack` method. 
  * Start by resetting the deck and telling the players to start a new game. 
  * Then, deal a new round (`newDeal`). 
  * Since some Blackjack rules allow a hand limit of five cards, create a loop with a maximum of three iterations. Within the loop, give the player its turn, and then the house. Keep in mind that as soon as the player or the house busts, the round is over. Detect a bust after each dealt card by evaluating the `busted` property for the player or the house respectively. **Hint:** *Use the* `break;` *keyword to escape a loop without escaping the method.*
  * After the loop ends, evaluate the winner by calling the `houseWins` method and use the `incrementWinsAndLossesForHouseWins:` to keep the tally of the rounds.
  * Finally, use a pair of `NSLog()`s to print the descriptions of `player` and `house` to the console. 

8. Navigate the `FISAppDelegate.m` file and import `FISBlackjackGame.h`. It's time to play some Blackjack! Inside the `application:didFinishLaunchingWithOptions:` method, create an instance of `FISBlackjackGame` called `game`. Call `playBlackjack` on `game` a few times. Run the scheme with `⌘` `R` and watch the results of the hands appear in the debug console!

```
2015-10-02 16:28:41.638 BlackJack[9979:383041] House wins!
2015-10-02 16:28:41.638 BlackJack[9979:383041] FISBlackjackPlayer:
  name: Player
  cards: ♦9 ♥8 ♣Q
  handscore  : 27
  ace in hand: 0
  stayed     : 0
  blackjack  : 0
  busted     : 1
  wins  : 0
  losses: 1
2015-10-02 16:28:41.639 BlackJack[9979:383041] FISBlackjackPlayer:
  name: House
  cards: ♥10 ♥6
  handscore  : 16
  ace in hand: 0
  stayed     : 0
  blackjack  : 0
  busted     : 0
  wins  : 1
  losses: 0
2015-10-02 16:28:41.639 BlackJack[9979:383041] Player wins!
2015-10-02 16:28:41.640 BlackJack[9979:383041] FISBlackjackPlayer:
  name: Player
  cards: ♠A ♣K
  handscore  : 21
  ace in hand: 1
  stayed     : 1
  blackjack  : 1
  busted     : 0
  wins  : 1
  losses: 1
2015-10-02 16:28:41.640 BlackJack[9979:383041] FISBlackjackPlayer:
  name: House
  cards: ♠5 ♦5 ♠4 ♦8
  handscore  : 22
  ace in hand: 0
  stayed     : 0
  blackjack  : 0
  busted     : 1
  wins  : 1
  losses: 1
2015-10-02 16:28:41.640 BlackJack[9979:383041] House wins!
2015-10-02 16:28:41.698 BlackJack[9979:383041] FISBlackjackPlayer:
  name: Player
  cards: ♣Q ♣5 ♠Q
  handscore  : 25
  ace in hand: 0
  stayed     : 0
  blackjack  : 0
  busted     : 1
  wins  : 1
  losses: 2
2015-10-02 16:28:41.699 BlackJack[9979:383041] FISBlackjackPlayer:
  name: House
  cards: ♥A ♣J
  handscore  : 21
  ace in hand: 1
  stayed     : 0
  blackjack  : 1
  busted     : 0
  wins  : 2
  losses: 1
```

## Advanced

These are some options for continuing to work on this concept beyond the provided testing suite. You should checkout a new branch called `advanced` to avoid destroying your solution. These assignments may break the test successes that you've accomplished, so rely on behavioral testing via `NSLog()`s in the `FISAppDelegate` to check your code.

1. Refactor the `dealCardToPlayer` and `dealCardToHouse` methods into a single method that accepts a `FISBlackjackPlayer` argument and uses the same logic to deal to either player.

2. Refactor the `playerTurn` and `houseTurn` methods into a single method that accepts ` FISBlackjackPlayer` argument and uses the same logic to offer a turn to both players.

3. Refactor the `houseWins` method to accommodate the possibility of a "push" (when both the House and the Player have blackjack hands). Can you accomplish this while returning a `BOOL`? (*Probably not.*) Should the method still be called `houseWins` after you've changed the way it works?

3. Add additional "seats" to the game, meaning, add additional `FISBlackjackPlayer` instances. Will you add them as properties, or convert the `player` property into an array of players? Remember that Blackjack is scored individually against the house, but all of the players are dealt from the same deck. If you've added players to table, do you need more cards in the deck? Casinos usually run blackjack games with triple (3) or sextuple (6) decks shuffled together. How can you alter the `FISCardDeck` class to accommodate this?

4. Add properties to the `FISBlackPlayer` class to save information about their current wallet and their current bet. Track the changes to this information when each round is evaluated (i.e. if the House wins, the House gets the bet).

5. Create a subclass of `FISBlackjackPlayer` called `FISBlackjackShark`. Override the `decideToHit` method from the parent class to evaluate the best move in accordance with a [Blackjack strategy card](https://blackjack.press/wp-content/uploads/2014/12/advanced-blackjack-strategy-bj-press.jpg). 
  * (Easy) Make a decision based upon whether the current hand score is soft (contains an Ace) or hard (without an Ace). 
  * (Hard) Make a decision based upon the cards currently in the House's hand. How can you transport this information from the instance of `FISBlackjackGame` to the instance of `FISBlackjackShark`? Should the shark try to get that information on its own, or should the game be responsible for handing this information to the shark every time the house takes a card?

