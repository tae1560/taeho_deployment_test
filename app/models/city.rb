class City < ActiveRecord::Base
  attr_accessible :name, :cortarNo

  def self.duplicated? cortarNo
    City.where(:cortarNo => cortarNo).exists?
  end
end
