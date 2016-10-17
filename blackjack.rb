require_relative 'deck'
require_relative 'shoe'

class Game
  attr_accessor :player_hand,
                :dealer_hand,
                :deck_o_cards,
                :player_value,
                :dealer_value,
                :phand,
                :final_dealer_hand,
                :win_tracker,
                :loss_tracker,
                :blackjacks,
                :busts

  def initialize
    self.win_tracker = 0
    self.loss_tracker = 0
    self.blackjacks = 0
    self.busts = 0
  end

  def player_total_value
    self.player_value = player_hand.reduce(0) { |sum, value| sum + value.value }
  end

  def dealer_total_value
    self.dealer_value = dealer_hand.reduce(0) { |sum, value| sum + value.value }
  end

  def play
    prepare_deck
    deal
    rounds unless blackjack? || dealer_blackjack?
    winner
    rematch?
  end

  def prepare_deck
    self.deck_o_cards = Shoe.new
    self.player_hand = []
    self.dealer_hand = []
    self.player_value = 0
    self.dealer_value = 0
    self.phand = []
    self.final_dealer_hand = []
  end

  def deal
    2.times do
      player_hand << deck_o_cards.draw
      dealer_hand << deck_o_cards.draw
    end
  end

  def rounds
    player_total_value
    dealer_total_value
    show_hand
    puts "You have #{player_value} with #{phand}."
    puts "The dealer shows #{dealer_hand[1]}"
    player_ace_choice
    unless blackjack? || bust?
      puts 'Would you like a hit? (hit / stay)'
      need = gets.chomp.downcase
      player_hit if need == 'hit'
    end
    unless blackjack? || bust? || player_six_win
      dealer_turn
      show_dealer_hand
    end
  end

  def dealer_turn
    dealer_total_value
    unless dealer_bust
      if dealer_value < 16
        dealer_hit
        dealer_turn
      end
    end
  end

  def player_hit
    unless blackjack? || bust? || player_six_win
      player_hand << deck_o_cards.draw
      player_total_value
      show_hand
      puts "#{player_value} with #{phand}"
      player_ace_choice
    end
    unless blackjack? || bust? || player_six_win
      puts 'Another (hit / stay)'
      another = gets.chomp.downcase
      player_hit if another == 'hit'
    end
  end

  def dealer_hit
    show_dealer_hand
    puts "The dealer shows: #{final_dealer_hand}"
    puts '(return to continue)'
    gets
    dealer_hand << deck_o_cards.draw
    puts 'The dealer takes a hit'
    puts 'The dealer is now showing:'
    puts dealer_hand
    puts '(return to continue)'
    gets
  end

  def blackjack?
    player_value == 21
  end

  def bust?
    player_value > 21
  end

  def dealer_bust
    dealer_value > 21
  end

  def player_six_win
    player_hand.length == 6 && player_value < 21
  end

  def dealer_blackjack?
    dealer_value == 21
  end

  def winner
    if blackjack?
      puts 'Blackjack!!! You win!!!'
      self.blackjacks += 1
      self.win_tracker += 1
      final_hands
    elsif bust?
      puts 'Bust! Sorry you lose!'
      self.busts += 1
      self.loss_tracker += 1
      final_hands
    elsif player_six_win
      puts 'Charlie!  You win with 6 cards and staying under 21'
      self.win_tracker += 1
      final_hands
    elsif player_value > dealer_value
      puts "Your #{player_value} beats the dealer's #{dealer_value}!"
      self.win_tracker += 1
      final_hands
    elsif player_value == dealer_value
      tie_breaker
    elsif dealer_bust
      puts 'Bust!! The dealer lost!  You win!!'
      self.win_tracker += 1
      final_hands
    else
      puts "The dealer's #{dealer_value} beats your #{player_value}, sorry."
      self.loss_tracker += 1
      final_hands
    end
  end

  def tie_breaker
    if dealer_hand.length > player_hand.length
      puts "You lose the tie with #{player_hand.length} cards."
      puts "The dealer had #{dealer_hand.length} cards!"
      self.loss_tracker += 1
    else
      puts "You win the tie with #{player_hand.length} cards!"
      puts "The dealer had #{dealer_hand.length} cards."
      self.win_tracker += 1
    end
    final_hands
  end

  def final_hands
    show_hand
    show_dealer_hand
    puts "Your final hand: #{player_value} from #{phand}"
    puts "The dealer's final hand: #{dealer_value} from #{final_dealer_hand} "
    combined_stats
  end

  def combined_stats
    puts "You have won: #{win_tracker} games!"
    puts "You have lost: #{loss_tracker} games!"
    puts "You have had: #{blackjacks} blackjacks!"
    puts "You have busted: #{busts} times!"
  end

  def rematch?
    puts 'Would you like to play a new game? (y / n)'
    desire = gets.chomp.downcase
    if desire == 'y'
      play
    else
      exit
    end
  end

  def player_ace_choice
    while player_hand.include? 'Ace'
      puts 'Would you like your Ace to be worth 1 or 11? (1 / 11)'
      player_choice = gets.chomp
      card.value =
        1 if player_choice == 1
    end
  end

  def show_hand
    self.phand = player_hand.collect(&:to_s).join(' & ')
  end

  def show_dealer_hand
    self.final_dealer_hand = dealer_hand.collect(&:to_s).join(' & ')
  end
end

Game.new.play
