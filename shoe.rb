require_relative 'card'
class Shoe < Deck
  attr_accessor :card_holder

  def initialize
    create_deck
    shuffle_cards
  end

  def create_deck
    self.card_holder = []
    7.times do
      Card.faces.each do |face|
        Card.suits.each do |suit|
          card_holder << Card.new(face, suit)
        end
      end
    end
  end

  def shuffle_cards
    card_holder.shuffle!
  end

  def draw
    card_holder.shift
  end
end
