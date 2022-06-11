require 'rails_helper'

describe 'Admin entra na página de cadastro' do
  it 'e registra com sucesso' do
    visit new_admin_registration_path
    click_on 'Cadastrar-se'
    fill_in 'Nome', with: 'Manoel da Silva'
    fill_in 'E-mail', with: 'manoel@mercadores.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar senha', with: '123456'
    click_on 'Cadastrar'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Manoel da Silva')
    expect(Admin.count).to eq 1
  end

  it 'e tenta registrar domínio diferente sem sucesso' do
    visit new_admin_registration_path
    click_on 'Cadastrar-se'
    fill_in 'Nome', with: 'Manoel da Silva'
    fill_in 'E-mail', with: 'manoel@dominiodiferente.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar senha', with: '123456'
    click_on 'Cadastrar'

    expect(current_path).to eq(admin_registration_path)
    expect(page).to have_content('E-mail com domínio inválido')
    expect(Admin.count).to eq 0
  end
end