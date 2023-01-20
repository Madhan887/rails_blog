class User < ApplicationRecord
    include ActiveModel::SecurePassword

    has_many :books
    has_secure_password
end
