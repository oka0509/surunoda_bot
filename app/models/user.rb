class User < ApplicationRecord
  has_many :outs, dependent: :delete_all
end
