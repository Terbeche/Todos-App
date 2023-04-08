# frozen_string_literal: true
class User < ApplicationRecord
    has_many :todos, dependent: :destroy

    validates :email,
              presence: true,
              uniqueness: { case_sensitive: false },
              format: { with: URI::MailTo::EMAIL_REGEXP }
  
    passwordless_with :email
  end