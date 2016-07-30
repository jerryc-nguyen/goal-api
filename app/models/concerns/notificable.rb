module Notificable
  extend ActiveSupport::Concern

  included do
    has_one :notification, as: :notificable,  dependent: :destroy
  end

end
