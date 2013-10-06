class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  # attr_accessible :title, :body
  has_many :ads, dependent: :destroy
  ROLES = %w[guest user admin]
  def role?(base_role)
  	ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
end
