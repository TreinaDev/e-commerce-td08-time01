require 'rails_helper'

describe 'Unlogged user logs in as an admin' do
  it 'succesfully' do
    create(:admin, name: 'João do Rêgo')

    visit new_admin_session_path
    within '.form-signin' do
      fill_in 'E-mail', with: 'joao@mercadores.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content 'João do Rêgo'
    expect(page).to have_content 'Bem vindo!'
  end

  it 'but it fails due to wrong credentials' do
    create(:admin, name: 'João do Rêgo', password: '123456')
      
    visit new_admin_session_path
    within '.form-signin' do
      fill_in 'E-mail', with: 'joao@mercadores.com.br'
      fill_in 'Senha', with: '9999999'
      click_on 'Entrar'
    end

    expect(current_path).to eq(new_admin_session_path)
    expect(page).to have_content 'E-mail ou senha inválidos'
    expect(page).not_to have_content 'João do Rêgo'
  end
end