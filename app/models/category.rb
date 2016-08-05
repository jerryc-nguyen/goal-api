class Category < ActiveRecord::Base
  has_many    :goals
  belongs_to  :user

  DEFAULT_SERIALIZER = Api::CategorySerializer
  
  validates_uniqueness_of :name, scope: [:user_id]

  #need validate name scope on user before create!

end
