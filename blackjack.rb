require_relative 'deck'

class Game
  attr_accessor :player_hand, :dealer_hand, :deck_o_cards, :player_value, :dealer_value, :phand

  def initialize
    self.player_hand = []
    self.dealer_hand = []
    self.player_value = 0
    self.dealer_value = 0
    self.phand = []
  end

  def player_total_value
    self.player_value = player_hand.reduce(0) { |sum, value| sum + value.value}
  end

  def dealer_total_value
    self.dealer_value = dealer_hand.reduce(0) { |sum, value| sum + value.value}
  end

  def play
    prepare_deck
    deal
    rounds if !blackjack
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
    puts "#{player_total_value}"
    puts "You have #{phand}, the dealer shows #{dealer_hand[1]}"
    puts "Would you like a hit? (hit / stay)"
    need = gets.chomp.downcase

    if need == "hit"
      hit(player_hand)
    end
    dealer_turn
  end


  def dealer_turn
    dealer_total_value
    if dealer_value < 16
      hit(dealer_hand)
      dealer_turn
    end
  end

  def hit(active_player)
    if active_player == player_hand
      player_hand << deck_o_cards.draw
      player_total_value
      show_hand
      puts "#{player_value} with#{phand}"
      puts "Another (hit / stay)"
      another = gets.chomp.downcase
      if another == "hit"
        hit(active_player)
      end
    else
      dealer_hand << deck_o_cards.draw
    end
  end

  def blackjack
    player_value == 21
  end

  def bust
    player_value > 21
  end

  def winner
    if blackjack
      puts "Blackjack!!! You win!!!"
    elsif bust
      puts "Bust! Sorry you lose!"
    elsif player_value > dealer_value
      puts "Your #{player_value} beats the dealer's #{dealer_value}!"
      puts "Your final hand: #{phand}"
      puts "The dealer's final hand: #{} "
    else
      puts "The dealer's #{dealer_value} beats your #{player_value}, sorry."
    end
  end

  def rematch?
    puts "Would you like to play a new game? (y / n)"
    desire = gets.chomp.downcase
    if desire == "y"
      initialize
      play
    else
      exit
    end
  end

  def show_hand
    self.phand = player_hand.collect {|card| card.to_s}
  end



end


Game.new.play
