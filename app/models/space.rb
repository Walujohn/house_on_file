class Space < ApplicationRecord
  belongs_to :property
  has_many :features, dependent: :destroy
    
  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }
    
  def previous_space
      property.spaces.ordered.where("name < ?", name).last
  end
end
