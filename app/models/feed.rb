class Feed < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  belongs_to :category
end
