require 'rails_helper'

describe 'Non-admin users get redirect out of the ProductCategory index' do
  it 'when they are unlogged' do
    visit product_categories_path

    expect(current_path).to eq(root_path)
  end

  it 'when they are logged-in as a costumer' do
    user = create(:user)

    login_as(user, scope: :user)
    visit product_categories_path

    expect(current_path).to eq(root_path)
  end
end