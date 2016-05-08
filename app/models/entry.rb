class Entry < ActiveRecord::Base
  belongs_to :feed

  default_scope { order('published desc') }
end
