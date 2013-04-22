class Town < ActiveRecord::Base
  attr_accessible :name, :cortarNo

  belongs_to :city

  def self.duplicated? cortarNo
    Town.where(:cortarNo => cortarNo).exists?
  end
end
