require 'pry'

class Card

  def initialize(face, suit, hidden)
    @face = face
    @suit = suit
    @hidden = hidden
  end

  def show_card
    !@hidden ? "#{@face} of #{@suit}" : "The card is face down."
  end

  def card_value
    if @face == "J" || @face == "Q" || @face == "K"
      value = 10
    elsif @face == 1
      value = 11
    else
      value = @face
    end
  end

  def show
    @hidden = false
  end

end

class Dealer

  attr_accessor :hand, :name, :tally

  def initialize(name)
    @name = name
    @hand = []
    @tally = 0
  end

  def display_hand
    puts "#{self.name} has the following cards: "
    @hand.each do |this_card|
      puts this_card.show_card
    end
  end

  def calculate_total
    total = 0
    ace_count = 0
    @hand.each do |card|
      total += card.card_value
      ace_count += 1 if card.card_value == 11
    end
    ace_count.times do
      total -= 10 if total > Game::BLACKJACK
    end
    return total
  end

  def busted?
    self.calculate_total > Game::BLACKJACK
  end

  def blackjack?
    self.calculate_total == Game::BLACKJACK
  end

end

class Deck

  def initialize(number_of_packs)
    @cards = []
    @number_of_packs = number_of_packs
    add_pack(@number_of_packs)
  end

  def add_pack(pack_count)
    deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"]
    suits = ["H", "D", "C", "S"]
    shuffled_deck = (deck.product(suits) * pack_count).shuffle
    shuffled_deck.each do |card_array|
      @cards << Card.new(card_array[0],card_array[1],true)
    end
  end

  def deal_card(recipient, show=true)
    my_card = @cards.pop
    my_card.show if show
    recipient.hand << my_card
  end

end

class Game

  DEALER_STAY = 17
  BLACKJACK = 21

  attr_accessor :player, :dealer, :deck

  def initialize(player, dealer, deck)
    @player = player
    @dealer = dealer
    @deck = deck
  end

  def play
    result = play_detail
    player.tally += 1 if result > 0
    dealer.tally += 1 if result < 0
    play_again = "Y"
    while play_again.upcase == "Y" do
      tally = player.tally - dealer.tally
      plural = tally.abs == 1 ? "" : "s"
      if tally > 0
        puts "Congratulations!  You are ahead by #{tally} game#{plural}."
      elsif tally < 0
        puts "Today is not your day. I am ahead by #{tally.abs} game#{plural}."
      else
        puts "Looks like we're tied on games won."
      end
      puts "Would you like to play again? Please type in 'Y' for 'Yes' and 'N' for 'No'."
      play_again = gets.chomp
      until ["Y", "N"].include?(play_again.upcase) do
        puts "Oops! Please type in 'Y' for 'Yes' and 'N' for 'No'."
        play_again = gets.chomp
      end
      if play_again.upcase == "N"
        puts "Thanks for playing Blackjack!"
      else
        player.hand = []
        dealer.hand = []
        result = play_detail
        player.tally += 1 if result > 0
        dealer.tally += 1 if result < 0
      end
    end
  end

  def play_detail
    2.times do
      self.deck.deal_card(player)
      self.deck.deal_card(dealer, false)
    end
    dealer.hand.last.show
    player_total = player.calculate_total
    dealer_total = dealer.calculate_total
    if player.blackjack?
      player.display_hand
      dealer.display_hand
      puts "Congratulations, #{player.name}! You just hit Blackjack."
      return 1
    end
    if dealer.blackjack?
      dealer.hand.first.show
      player.display_hand
      dealer.display_hand
      puts "So sorry, #{player.name}! I just hit Blackjack."
      return -1
    end
    player.display_hand
    puts "Do you want to hit or stay? Select 'H' for 'Hit' or 'S' for 'Stay'"
    hit_or_stay = gets.chomp

    while hit_or_stay.upcase != "S" do
      if hit_or_stay.upcase == "H"
        self.deck.deal_card(player)
        player_total = player.calculate_total
        if player.busted?
          player.display_hand
          dealer.display_hand
          puts "So sorry, #{player.name}, but I'm afraid that you're busted!"
          return -1
        end
      elsif hit_or_stay.upcase != "S"
        puts "Please select 'H' for 'Hit' or 'S' for 'Stay'."
      end
      player.display_hand
      puts "Do you want to hit or stay? Select 'H' for 'Hit' or 'S' for 'Stay'."
      hit_or_stay = gets.chomp
    end

    dealer.hand.first.show

    while dealer_total < DEALER_STAY do
      self.deck.deal_card(dealer)
      dealer_total = dealer.calculate_total
      if dealer_total > BLACKJACK
        player.display_hand
        dealer.display_hand
        puts "Great news, #{player.name}! I just got busted. You won!"
        return 1
      end
    end

    player.display_hand
    dealer.display_hand

    if player_total > dealer_total
      puts "Congratulations, #{player.name}! You won!"
      return 1
    elsif dealer_total > player_total
      puts "Sorry about that, #{player.name}! I won. Better luck next time!"
      return -1
    else
      puts "You're not going to believe this, #{player.name}, but it's a tie!"
      return 0
    end

  end

end

class Player < Dealer

  def initialize(name, money)
    @name = name
    @money = money
    @hand = []
    @tally = 0
  end

end

puts "Welcome to Blackjack!"
puts "I'm going to be the dealer, and my name is Joe."
puts "If you don't mind me asking, what's your name?"
name = gets.chomp
puts "Nice to meet you, #{name}! Let's get started."
puts
my_player = Player.new(name, 500)
dealer = Dealer.new("Dealer")
deck = Deck.new(1)

game = Game.new(my_player, dealer, deck)
game.play
