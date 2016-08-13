class Category < ActiveRecord::Base
  has_many    :goals
  belongs_to  :user

  def selected_color
    color || Settings.goals.colors[name.downcase] || Settings.goals.default_category_color
  end

  DEFAULT_SERIALIZER = Api::CategorySerializer
  
  validates_uniqueness_of :name, scope: [:user_id]

  #need validate name scope on user before create!

end
