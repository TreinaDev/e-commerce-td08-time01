require 'rails_helper'

describe 'Um usuário não autenticado como administrador tenta entrar Categorias de Produtos' do
  it 'e o sistema o redireciona quando é um visitante' do
    visit product_categories_path
    expect(current_path).to eq(root_path)
  end

  it 'e o sistema o redireciona quando é um cliente autenticado' do
    user = create(:user)

    login_as(user, scope: :user)
    visit product_categories_path
    expect(current_path).to eq(root_path)
  end

end
