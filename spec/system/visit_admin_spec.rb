require 'rails_helper'

describe 'Administrador deslogado acessa página de login' do
  it 'e a vê' do
    visit root_path
    click_on 'Admin'

    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Entrar'
  end

  it 'e faz o login com sucesso' do
    Admin.create!(name: 'João do Rêgo', email: 'joao@mercadores.com.br', password: '123456')

    visit root_path
    click_on 'Admin'
    within 'form' do
      fill_in 'E-mail', with: 'joao@mercadores.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content 'João do Rêgo'
    expect(page).to have_content 'Bem vindo!'
  end
end