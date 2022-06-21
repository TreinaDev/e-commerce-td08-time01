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
    if cpf_cnpj.length == 11
      errors.add(:identify_number, "inválido.") if !CPF.valid?(cpf_cnpj)
    elsif cpf_cnpj.length == 14
      errors.add(:identify_number, "inválido.") if !CNPJ.valid?(cpf_cnpj)
    else
      errors.add(:identify_number, "precisa ter 11 ou 14 caracteres.")
    end
  end
  

 
  
 #  def valid_cpf(cpf_cnpj = self.identify_number)
 #    if !CPF.valid?(cpf_cnpj)
 #      errors.add(:identify_number, "inválido.")
 #    end
 #  end
 #
 #  def cnpj_validator
 #    if CNPJ.valid?(cnpj, strict: true) == true
 #      register_id = CNPJ.new(cnpj)
 #      self.cnpj = register_id.formatted
 #    else
 #      errors.add(:cnpj, 'não é válido')
 #    end
 #  end

end
