class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: ' inválido.' }
  validates :email, uniqueness: true

  validate :valid_cpf_cnpj

  after_create :sync_user_on_payment

  def to_payment_client
    client_type = self.identify_number.length == 11 ? "client_person" : "client_company"
    identify_number_type = self.identify_number.length == 11 ? "cpf" : "cnpj"
    client_attributes_type = self.identify_number.length == 11 ? "client_person_attributes" : "client_company_attributes"
    client_name = self.identify_number.length == 11 ? "full_name" : "company_name"

    payment_client = {
      "client": {
        "client_type": client_type,
        "#{ client_attributes_type }": {
                    "#{ client_name }": self.name,
                    "#{ identify_number_type }": self.identify_number
        } 
      }
    }

    payment_client.as_json
  end

  def sync_user_on_payment
    begin
      client = self.to_payment_client
      Faraday.post('http://localhost:4000/api/v1/clients', client)
    rescue
    end
  end

  def get_balance
    begin
      payload = { "registration_number": "#{ identify_number }" }.as_json
      result = Faraday.get('http://localhost:4000/api/v1/clients_info', payload)
    
      return JSON.parse(result.body)["client_info"]["balance"] if result.status == 200

      0
    rescue
      0
    end
  end
 
  private

  def valid_cpf_cnpj(cpf_cnpj = self.identify_number)
    if cpf_cnpj.nil?
    elsif cpf_cnpj.length == 11
      errors.add(:identify_number, "inválido.") if !CPF.valid?(cpf_cnpj)
    elsif cpf_cnpj.length == 14
      errors.add(:identify_number, "inválido.") if !CNPJ.valid?(cpf_cnpj)
    else
      errors.add(:identify_number, "precisa ter 11 ou 14 caracteres.")
    end
  end
 
end
