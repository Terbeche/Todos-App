class User < ApplicationRecord
   # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :todos, dependent: :destroy
  
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(email) = :value", { value: login.downcase }]).first
      else
        where(conditions.to_h).first
      end
    end
  
    def login=(login)
      @login = login
    end
  
    def login
      @login || self.email
    end
  
    def email_required?
      false
    end
end