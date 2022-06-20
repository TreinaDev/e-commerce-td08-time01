class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: ' inválido.' }
  validates :email, uniqueness: true
  validate :valid_cpf


  private

  def valid_cpf(cpf = self.cpf)
    if !CPF.valid?(cpf)
      errors.add(:cpf, "inválido.")
    end
  end

end
