class User < ApplicationRecord
  has_many :outs, dependent: :destroy
end
