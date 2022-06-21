require 'rails_helper'

describe 'Someone tries to create a costumer account' do
  it 'and is succesful' do
    cpf = '69907388041'

    visit root_path
    click_on 'Registrar'
    fill_in 'Nome', with: 'Cláudio Roberto'
    fill_in 'E-mail', with: 'claudio@meuemail.com'
    fill_in 'CPF/CNPJ', with: cpf
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar senha', with: '123456'
    click_on 'Cadastrar-se'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Cláudio Roberto'
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(User.count).to eq 1
    expect(User.last.identify_number).to eq '69907388041'
  end

  it 'and fail when cpf is invalid' do
    cpf = '12345678910'

    visit root_path
    click_on 'Registrar'
    fill_in 'Nome', with: 'Cláudio Roberto'
    fill_in 'E-mail', with: 'claudio@meuemail.com'
    fill_in 'CPF/CNPJ', with: cpf
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar senha', with: '123456'
    click_on 'Cadastrar-se'

    expect(current_path).to eq users_path
    expect(page).to have_content 'CPF/CNPJ inválido.'
  end

  it 'it fails and they receive an error message' do
    visit root_path
    click_on 'Registrar'
    fill_in 'Nome', with: 'Cláudio Roberto'
    fill_in 'E-mail', with: 'claudio@meuemail.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar senha', with: '12346'
    click_on 'Cadastrar-se'

    expect(current_path).to eq user_registration_path
    expect(page).to have_content 'Senha de confirmação não confere.'
    expect(User.count).to eq 0
  end
end