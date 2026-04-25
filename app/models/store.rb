class Store < ApplicationRecord
    has_many :reviews, dependent: :destroy
end
