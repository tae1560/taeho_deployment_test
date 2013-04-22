class House < ActiveRecord::Base
  attr_accessible :trade_type, :house_type, :confirm_date, :name, :price

  belongs_to :town

  def self.duplicate? trade_type, house_type, confirm_date, name, price
    House.where(:trade_type => trade_type, :house_type => house_type, :confirm_date => confirm_date, :name => name, :price => price).exists?
  end
end
