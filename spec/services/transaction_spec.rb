require 'rails_helper'

RSpec.describe Transaction, type: :feature do
  describe '.new' do
    context 'should raise an error' do
      it 'if no CPF or CNPJ number is provided' do
        arguments = { user_tax_number: '',
                      value: 356,
                      transaction_type: 'transaction_order'}

        expect { Transaction.new(**arguments) }.to raise_error IncompleteData
      end

      it 'if no transaction value is provided' do
        arguments = { user_tax_number: '06001818398',
                      value: '',
                      transaction_type: 'transaction_order'}

        expect { Transaction.new(**arguments) }.to raise_error IncompleteData
      end

      it 'if the transaction value is not a number' do
        arguments = { user_tax_number: '06001818398',
                      value: '356',
                      transaction_type: 'transaction_order'}

        expect { Transaction.new(**arguments) }.to raise_error WrongTypeofParameter
      end

      it 'if the provided transaction type is not one of the types the API accepts' do
        arguments = { user_tax_number: '06001818398',
                      value: 356,
                      transaction_type: 'eat_ice_cream'}

        expect { Transaction.new(**arguments) }.to raise_error WrongTypeofParameter
      end
    end
  end

  describe '#request' do
    it 'should properly request the creation of a transaction to the Payments Dpt' do
      # in order to test the real call, comment out the next 3 lines
      fake_response = double('faraday_response', status: 201, 
                                                 body: '{ "code": "nsurg745n" }')
      allow(Faraday).to receive(:post).and_return(fake_response)

      transaction = Transaction.request(user_tax_number: '06001818398',
                                        value: 356,
                                        transaction_type: 'transaction_order')

      expect(transaction.response.status).to be 201 # created
      expect(transaction.response.body).to include 'code'
    end

    it 'should persist the transaction code of an Order' do
      fake_response = double('faraday_response', status: 201, 
                                                 body: '{ "code": "nsurg745n" }')
      allow(Faraday).to receive(:post).and_return(fake_response)
      user = create(:user)
      create(:cart_item, user: user)
      create(:order, user: user)

      Transaction.request(user_tax_number: '06001818398',
                          order_id: Order.last.id,
                          value: 356,
                          transaction_type: 'transaction_order')
    
      expect(Order.last.transaction_code).to eq 'nsurg745n'
    end
  end
end