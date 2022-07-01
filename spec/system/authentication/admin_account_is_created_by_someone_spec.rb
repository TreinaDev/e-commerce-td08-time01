require 'rails_helper'

describe 'Someone tries to create an admin account' do
  it 'and is succesful' do
    visit new_admin_registration_path
    click_on 'Cadastrar-se'
    fill_in 'Nome', with: 'Manoel da Silva'
    fill_in 'E-mail', with: 'manoel@mercadores.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar senha', with: '123456'
    click_on 'Cadastrar'

    expect(current_path).to eq(admin_index_path)
    expect(page).to have_content('Manoel da Silva')
    expect(Admin.count).to be 1
  end

  it 'but is refused due to invalid email domain' do
    visit new_admin_registration_path
    click_on 'Cadastrar-se'
    fill_in 'Nome', with: 'Manoel da Silva'
    fill_in 'E-mail', with: 'manoel@dominiodiferente.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar senha', with: '123456'
    click_on 'Cadastrar'

    expect(current_path).to eq(admin_registration_path)
    expect(page).to have_content('E-mail com domínio inválido')
    expect(Admin.count).to be 0
  end
end