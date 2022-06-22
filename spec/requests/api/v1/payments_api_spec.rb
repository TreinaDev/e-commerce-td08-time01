require 'rails_helper'

describe 'PATCH api/v1/payment_results' do 
  it 'when done correctly returns 200 with success message' do
    user = create(:user)
    create(:cart_item, user: user)
    order = create(:order, status: 'pending', user: user)

    patch '/api/v1/payment_results', params: { transaction: { "code": "#{order.code}",
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
    user = create(:user)
    create(:cart_item, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ASDF1234')
    order = create(:order, user: user)

    patch '/api/v1/payment_results', params: { transaction: { "code": "4567-QWER",
                                                              "status": "approved",
                                                              "error_type": "" } }
    body = response.body

    expect(response.status).to eq 404
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Transação desconhecida.'
  end
  
  it 'returns 422 when the payload status is invalid' do
    user = create(:user)
    create(:cart_item, user: user)
    order = create(:order, status: 'pending', user: user)

    patch '/api/v1/payment_results', params: { transaction: { "code": "#{order.code}",
                                                              "status": "happy",
                                                              "error_type": "" } }
    body = response.body

    expect(response.status).to eq 422
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Status inválido.'
    expect(order.status).to eq 'pending'
  end

  it 'returns 422 if a canceled transaction has nothing inside error_type' do
    user = create(:user)
    create(:cart_item, user: user)
    order = create(:order, user: user)
    
    patch '/api/v1/payment_results', params: { transaction: { "code": "#{order.code}",
                                                              "status": "canceled",
                                                              "error_type": "" } }
    body = response.body
    
    expect(response.status).to eq 422
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'O tipo de erro é obrigatório quando a transação foi recusada (status: "canceled").'
  end

  it 'returns 500 if some error occurs inside the server' do
    allow(Order).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

    patch '/api/v1/payment_results', params: { transaction: { "code": "4567-QWER",
                                                              "status": "completed",
                                                              "error_type": "" } }
    body = response.body

    expect(response.status).to eq 500
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Alguma coisa deu errado, por favor contate o suporte.'
  end
end