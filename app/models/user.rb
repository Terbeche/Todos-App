# frozen_string_literal: true

class User < ApplicationRecord
  has_many :todos, dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email

  def self.fetch_resource_for_passwordless(email)
    find_or_create_by(email:)
  end
end
