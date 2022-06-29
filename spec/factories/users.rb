FactoryBot.define do
  factory :user do
    name { 'José da Silva'}
    email {'jose@meuemail.com'}
    identify_number { CPF.generate }
    password { '123456' }
  end
end
