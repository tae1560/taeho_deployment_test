class Town < ActiveRecord::Base
  attr_accessible :name, :cortarNo

  belongs_to :city
  has_many :houses

  def self.duplicated? cortarNo
    Town.where(:cortarNo => cortarNo).exists?
  end
end
