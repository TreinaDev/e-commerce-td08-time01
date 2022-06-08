require 'rails_helper'

describe 'Usuário deslogado acessa página de login' do
  it 'e a vê' do
    visit root_path
    click_on 'Entrar'

    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Entrar'
  end

  it 'e faz o login no site' do
    user = User.create!(email: 'jose@meuemail.com', password: '123456', name: 'José da Silva')

    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    within('form') do
      fill_in 'E-mail', with: 'jose@meuemail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content 'José da Silva'
    expect(page).to have_content 'Bem vindo!'
  end
end