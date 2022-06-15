require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    before { FactoryBot.build(:admin) }

    context 'regarding presence' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:password) }
    end

    context 'regarding format' do
      it { should allow_value('name@mercadores.com.br').for(:email) }
      it { should_not allow_value('name.mercadores.com.br').for(:email) }
      it { should_not allow_value('name@mercadores').for(:email) }
      it { should_not allow_value('name@mercadores.com').for(:email) }
      it { should_not allow_value('@mercadores.com.br').for(:email) }
    end
  end
end