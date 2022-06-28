require 'rails_helper'

describe 'PATCH api/v1/payment_results' do 
  it 'when done correctly returns 200 with success message' do
    # below: mock for API call when creating an order
    fake_response = double('faraday_response', status: 201, 
                                                body: '{ "transaction_code": "nsurg745n" }')
    allow(Faraday).to receive(:post).and_return(fake_response)
      
    user = create(:user)
    create(:cart_item, user: user)
    create(:order, status: 'pending', user: user) 
    order = Order.last

    patch '/api/v1/payment_results', params: { transaction: { "code": "#{order.transaction_code}",
                                                              "status": "canceled",
                                                              "error_type": "insufficient_funds" } }
    body = response.body
    
    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Mensagem recebida com sucesso.'
    expect(Order.last.status).to eq "canceled"
    expect(Order.last.error_type).to eq "insufficient_funds"
  end

  it 'when done with incorrect identifier returns 404 with fail details' do
    # below: mock for API call when creating an order
    fake_response = double('faraday_response', status: 201, 
                                                body: '{ "transaction_code": "nsurg745n" }')
    allow(Faraday).to receive(:post).and_return(fake_response)

    user = create(:user)
    create(:cart_item, user: user)
    create(:order, user: user)
    order = Order.last

    patch '/api/v1/payment_results', params: { transaction: { "code": "asdgr654s",
                                                              "status": "approved",
                                                              "error_type": "" } }
    body = response.body

    expect(response.status).to eq 404
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Transação desconhecida.'
  end
  
  it 'returns 422 when the payload status is invalid' do
    # below: mock for API call when creating an order
    fake_response = double('faraday_response', status: 201, 
                                                body: '{ "transaction_code": "nsurg745n" }')
    allow(Faraday).to receive(:post).and_return(fake_response)
    
    user = create(:user)
    create(:cart_item, user: user)
    create(:order, status: 'pending', user: user)
    order = Order.last

    patch '/api/v1/payment_results', params: { transaction: { "code": "#{order.transaction_code}",
                                                              "status": "happy",
                                                              "error_type": "" } }
    body = response.body

    expect(response.status).to eq 422
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Status inválido.'
    expect(order.status).to eq 'pending'
  end

  it 'returns 422 if a canceled transaction has nothing inside error_type' do
    # below: mock for API call when creating an order
    fake_response = double('faraday_response', status: 201, 
                                                body: '{ "transaction_code": "nsurg745n" }')
    allow(Faraday).to receive(:post).and_return(fake_response)
    
    user = create(:user)
    create(:cart_item, user: user)
    create(:order, user: user)
    order = Order.last

    patch '/api/v1/payment_results', params: { transaction: { "code": "#{order.transaction_code}",
                                                              "status": "canceled",
                                                              "error_type": "" } }
    body = response.body
    
    expect(response.status).to eq 422
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'O tipo de erro não pode ficar em branco quando a transação foi recusada (status: "canceled").'
  end

  it 'returns 500 if some error occurs inside the server' do
    allow(Order).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

    patch '/api/v1/payment_results', params: { transaction: { "code": "nsurg745n",
                                                              "status": "completed",
                                                              "error_type": "" } }
    body = response.body

    expect(response.status).to eq 500
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Alguma coisa deu errado, por favor contate o suporte.'
  end
end