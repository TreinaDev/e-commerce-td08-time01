require 'rails_helper'

describe "Usuário adiciona produto ao carrinho" do
  it "e deve estar autenticado" do
    create(:product, name: 'Caneca Mon Amour')

    visit root_path
    click_on 'Caneca Mon Amour'
    click_on 'Adicionar ao carrinho'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Bem vindo! Por favor registre-se ou entre em sua conta para continuar.'
  end

  it "com sucesso" do
    create(:product, name: 'Caneca Mon Amour')
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Caneca Mon Amour'
    fill_in 'Quantidade', with: 1
    click_on 'Adicionar ao carrinho'

    expect(page).to have_content('Produto adicionado com sucesso') 
  end
end