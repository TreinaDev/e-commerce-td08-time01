class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: ' inválido.' }
  validates :email, uniqueness: true
  validate :valid_cpf_cnpj


  private

  def valid_cpf_cnpj(cpf_cnpj = self.identify_number)
    if !CPF.valid?(cpf_cnpj)
      errors.add(:identify_number, "inválido.")
    end
  end

end
