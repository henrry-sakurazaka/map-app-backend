class User < ApplicationRecord
    has_secure_password
    has_many :reviews
    validates :email, presence: true, uniqueness: true

    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
            user.provider = auth.provider
            user.uid = auth.uid
            user.name = auth.info.name
            user.email = auth.info.email
            user.image_url = auth.info.image
            user.access_token = auth.credentials.token
            user.save!
        end
    end
end
