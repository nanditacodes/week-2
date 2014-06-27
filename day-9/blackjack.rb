require 'io/console'
require 'colorize'

class BlackjackException < StandardError
end

class BustedException < StandardError
end

class WinnerException < StandardError
end

class Card
  attr_accessor :rank, :suit, :value
  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def show_card
    suit_images = {
      "Hearts" => ["♡",:red],
      "Clubs" =>["♧",:black],
      "Spades" => ["♤",:black],
      "Diamonds" => ["♢",:red]
    }
    puts "#{@rank} of #{suit_images[@suit].first}".colorize(suit_images[@suit].last).bold

  end

  def get_card_value

    if (%w(J K Q).include?(@rank))
      @value = 10
    elsif (@rank == "Ace")
      @value = 11
    else
      @value = @rank
    end
  end

end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def init_deck
    rank = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Ace", "J", "Q", "K"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    the_shuffled_deck = rank.product(suits).shuffle
    the_shuffled_deck.each do |card|
      @cards << Card.new(card.first,card.last)
    end

  end

  def deal_cards(hand)
    puts "#{hand.name} gets a card...".yellow
    card = cards.pop
    hand.cards << card
  end

end

class Hand
  attr_accessor :name, :cards, :total

  def initialize(name)
    @name = name
    @cards = []
    @total = 0
  end

  def display_cards
    puts "#{self.name}'s  cards:".red
    @cards.each do |card|
       card.show_card
    end
    puts "---------------------"
    puts "#{self.name}'s total: #{total}".magenta
    puts "---------------------"
  end

  def calculate_total
    self.total = @cards.map(&:get_card_value).inject(:+)
  end

  def busted?
    self.total > 21 ? true : false
  end

  def blackjack?
     self.total == 21 ? true : false
  end

end


class Blackjack
  attr_accessor :player, :dealer, :deck, :error_msg

  def initialize (player, dealer, deck)
    @player, @dealer, @deck = player, dealer, deck
    @error_msg = ""
  end

  def end_game_ritual
    puts "\n"
    puts self.error_msg.colorize(:red).bold
    puts "\n"
    dealer.display_cards
    player.display_cards
    self.error_msg = ""
  end

  def handle_blackjacks_if_any
    ret = false
    if (dealer.blackjack?)
      self.error_msg = "Dealer hit blackjack. Sorry #{player.name} - you lost this game."
      ret = true
    end

    if (player.blackjack?)
      self.error_msg = "Congratulations #{player.name} - you hit Blackjack!!!!."
      ret = true
    end
    end_game_ritual if ret
  end

  def compare_totals_and_declare_winner
    puts "Comparing totals..."
    if (player.total > dealer.total)
      self.error_msg = "Congratulations #{player.name}. Your total is higher, you won!!!"
    elsif (dealer.total > player.total)
      self.error_msg = "Dealer's total is higher. Sorry #{player.name}, you lost this game."
    else
      self.error_msg  = "Unbelievable - It is a Tie!!!!"
    end
    end_game_ritual
  end

  def play_game
    begin_the_2_deals
    ret = handle_blackjacks_if_any
    return if ret
    player.display_cards

    puts "Hit or Stay?? Type 'H' or 'S'"
    choice = STDIN.getch.upcase
    until choice.upcase == 'S' do
      deck.deal_cards(player)
      player.calculate_total

      if player.busted?
        self.error_msg = "Sorry #{player.name} - you are busted!!!"
        end_game_ritual
        return
      elsif player.blackjack?
        self.error_msg = "Congratulations #{player.name} - It is a Blackjack!!!"
        end_game_ritual
        return
      else
        player.display_cards
        puts "Hit or Stay?? Type 'H' or 'S'"
        choice = STDIN.getch.upcase
      end
    end

    until self.dealer.total > 16 do
      deck.deal_cards(dealer)
      dealer.calculate_total

      if dealer.busted?
        self.error_msg = "Dealer busted. Congratulations #{player.name}, you won!!!"
        end_game_ritual
        return
      elsif dealer.blackjack?
        self.error_msg = "Dealer hit BlackJack. Sorry #{player.name}!"
        end_game_ritual
        return
      else
        dealer.display_cards if self.dealer.total > 16
      end
    end

    puts "\nDealer's total is more than 16 - Dealer stays.".red
    handle_blackjacks_if_any
    # If you made it to this point, check totals and declare winner.
    compare_totals_and_declare_winner
   end
end



def begin_the_2_deals
  2.times do
    deck.deal_cards(player)
    deck.deal_cards(dealer)
  end
  puts "\nOne of dealer's card:".red
  dealer.cards.last.show_card
  dealer_total = dealer.calculate_total
  player_total = player.calculate_total

end

def another_game?
  puts "Another game? Type Y or N (any case)".red
  user_opt = STDIN.getch
  if (user_opt =~ /y/i)
    return true
  else
    return false
  end

end

def start_game
  name = print_welcome_message
  deck = Deck.new
  deck.init_deck

  player       = Hand.new(name)
  dealer       = Hand.new("Dealer")
  blackjack     = Blackjack.new(player, dealer, deck)
  blackjack.play_game
end

def print_welcome_message
  system "clear" or system "cls"
  puts "--------------------------------------------------"
  puts "            BLACKJACK TIME!!!".red
  puts "---------------------------------------------------"
 #`say -v Pipe  Welcome to Blackjack `

  puts "Hello! I am the Dealer. What's your name?"
  name = gets.chomp.strip
  puts "Hiya #{name}! Let's get started.\n "
  return name
end

# Entry point to this game
another_game = true
while another_game do
  start_game
  another_game = another_game?
end
