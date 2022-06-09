require 'rails_helper'

describe 'Usuário deslogado acessa página de login' do
  it 'e faz o login no site' do
    user = create(:user, name: 'José da Silva')

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

  it 'e não faz o login com sucesso' do
    create(:user, name: 'José da Silva')
      
    visit root_path
    click_on 'Entrar'
    within 'form' do
      fill_in 'E-mail', with: 'jose@meuemail.com'
      fill_in 'Senha', with: '12345'
      click_on 'Entrar'
    end

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content 'E-mail ou senha inválidos'
    expect(page).not_to have_content 'José da Silva'
  end
end