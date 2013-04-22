class House < ActiveRecord::Base
  attr_accessible :trade_type, :type, :confirm_date, :name, :price

  belongs_to :town

  def self.duplicate? trade_type, type, confirm_date, name, price
    House.where(:trade_type => trade_type, :type => type, :confirm_date => confirm_date, :name => name, :price => price).exists?
  end
end
