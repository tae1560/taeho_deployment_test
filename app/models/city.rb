class City < ActiveRecord::Base
  attr_accessible :name, :cortarNo

  has_many :towns

  def self.duplicated? cortarNo
    City.where(:cortarNo => cortarNo).exists?
  end
end
