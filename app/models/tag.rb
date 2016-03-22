class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :charts, through: :taggings
  def to_s
    name
  end
end
