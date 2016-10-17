class Card
  include Comparable

  def self.faces
    %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)
  end

  def self.suits
    %w(Clubs Diamonds Hearts Spades)
  end

  attr_accessor :face, :suit, :value

  def initialize(face, suit)
    self.face = face
    self.suit = suit
    card_value
  end

  def card_value
    self.value =
      if face == 'Ace'
        11
      elsif %w(King Queen Jack).include? face
        10
      else
        face.to_i
      end
  end

  def >(other)
    value > other.value
  end

  def <(other)
    value < other.value
  end

  def +(other)
    value + other.value
  end

  def to_s
    "a #{face} of #{suit}"
  end
end
