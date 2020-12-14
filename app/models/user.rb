class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  enum role: %i[standard premium admin]

  after_initialize do
    if self.new_record?
      self.role ||= :standard
    end
  end
end
