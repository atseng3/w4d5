class Cat < ActiveRecord::Base
  attr_accessible :name, :age, :birth_date, :color, :sex

  validates :name, :age, :birth_date, :color, :sex, :presence => true
  validates :color, :inclusion => {in: %w(red green blue),
    message: "%{value} is not a valid color"}
  validates :sex, :inclusion => {in: %w(M F),
    message: "%{value} is not a valid sex"}

  has_many :rental_requests,
    :primary_key => :id,
    :foreign_key => :cat_id,
    :class_name => "CatRentalRequest",
    :dependent => :destroy
end