class User < ApplicationRecord
  rolify 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :videos, dependent: :destroy

  after_create :assign_default_role, :send_admin_mail

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def admin?
    has_role?(:admin)
  end

  def active_for_authentication? 
    super && approved?
  end 
    
  def inactive_message 
    approved? ? super : :not_approved
  end

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end

  def self.send_reset_password_instructions(attributes={})
  recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
  if recoverable.persisted?
    if recoverable.approved?
      recoverable.send_reset_password_instructions
    else
      recoverable.errors.add(:base, :not_approved)
    end
  end
  recoverable
end

end
