require_relative 'deck'

class Game
  attr_accessor :player_hand, :dealer_hand, :deck_o_cards, :player_value, :dealer_value, :phand, :final_dealer_hand

  def initialize
    self.player_hand = []
    self.dealer_hand = []
    self.player_value = 0
    self.dealer_value = 0
    self.phand = []
    self.final_dealer_hand = []
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
    rounds unless blackjack!
    winner
    rematch?
  end

  def prepare_deck
    self.deck_o_cards = Deck.new
    deck_o_cards.shuffle_cards
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
    unless blackjack! || bust!
      puts 'Would you like a hit? (hit / stay)'
      need = gets.chomp.downcase

      hit(player_hand) if need == 'hit'
      unless blackjack! || bust!
        dealer_turn
        show_dealer_hand
      end
    end
  end

  def dealer_turn
    dealer_total_value
    unless dealer_bust
      if dealer_value < 16
        hit(dealer_hand)
        dealer_turn
      end
    end
  end

  def hit(active_player)
    if active_player == player_hand
      unless blackjack! || bust!
        player_hand << deck_o_cards.draw
        player_total_value
        show_hand
        puts "#{player_value} with #{phand}"
        unless blackjack! || bust!
          puts 'Another (hit / stay)'
          another = gets.chomp.downcase
          hit(active_player) if another == 'hit'
        end
      end
    else
      dealer_hand << deck_o_cards.draw
      puts 'The dealer takes a hit'
      puts 'The dealer is now showing:'
      puts dealer_hand[1, 2]
    end
  end

  def blackjack!
    player_value == 21
  end

  def bust!
    player_value > 21
  end

  def dealer_bust
    dealer_value > 21
  end

  def winner
    if blackjack!
      puts 'Blackjack!!! You win!!!'
      final_hands
    elsif bust!
      puts 'Bust! Sorry you lose!'
      final_hands
    elsif player_value > dealer_value
      puts "Your #{player_value} beats the dealer's #{dealer_value}!"
      final_hands
    elsif player_value == dealer_value
      puts "You win the tie! of #{player_value} to #{dealer_value}"
      final_hands
    elsif dealer_bust
      puts 'Bust!! The dealer lost!  You win!!'
      final_hands
    else
      puts "The dealer's #{dealer_value} beats your #{player_value}, sorry."
      final_hands
    end
  end

  def final_hands
    show_hand
    show_dealer_hand
    puts "Your final hand: #{player_value} from #{phand}"
    puts "The dealer's final hand: #{dealer_value} from #{final_dealer_hand} "
  end

  def rematch?
    puts 'Would you like to play a new game? (y / n)'
    desire = gets.chomp.downcase
    if desire == 'y'
      initialize
      play
    else
      exit
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
