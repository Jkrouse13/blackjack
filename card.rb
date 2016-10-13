class Card

  include Comparable

  def self.faces
    %w(A 2 3 4 5 6 7 8 9 10 J Q K)
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
    if face == "A"
      self.value = 11
    elsif face == "K"
      self.value = 10
    elsif face == "Q"
      self.value = 10
    elsif face == "J"
      self.value = 10
    else
      self.value = face.to_i
    end
  end

  def > (other)
    value.to_i > other.value.to_i
  end

  def < (other)
    value.to_i < other.value.to_i
  end

  def + (other)
    value.to_i + other.value.to_i
  end

  def to_s
    "a #{face} of #{suit}"
  end
end
