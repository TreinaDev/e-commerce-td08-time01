require 'rails_helper'

RSpec.describe Transaction, type: :feature do
  context '#request' do
    it 'should properly request the creation of a transaction to the Payments Dpt' do
      # in order to test the real call, comment out the next 3 lines
      fake_response = double('faraday_response', status: 201, 
                                                 body: '{ "transaction_code": "nsurg745n" }')
      allow(Faraday).to receive(:post).and_return(fake_response)

      transaction = Transaction.request(user_tax_number: '06001818398',
                                        value: 356,
                                        transaction_type: 'transaction_order')

      expect(transaction.response.status).to be 201 # created
      expect(transaction.response.body).to include 'transaction_code'
    end

    it 'should persist the transaction code of a Order' do
      user = create(:user)
      create(:cart_item, user: user)
      order = create(:order, user: user)
      Transaction.request(user_tax_number: '06001818398',
                          value: 356,
                          transaction_type: 'transaction_order')
    
      expect(order.transaction_code).to eq 'nsurg745n'
    end
  end
end