require 'rails_helper'

describe 'Unlogged user logs in as a costumer' do
  it 'succesfully' do
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

  it 'but it fails due to wrong credentials' do
    create(:user, name: 'José da Silva', password: '123456')
      
    visit root_path
    click_on 'Entrar'
    within 'form' do
      fill_in 'E-mail', with: 'jose@meuemail.com'
      fill_in 'Senha', with: '9999999'
      click_on 'Entrar'
    end

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content 'E-mail ou senha inválidos'
    expect(page).not_to have_content 'José da Silva'
  end
end