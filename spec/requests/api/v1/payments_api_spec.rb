require 'rails_helper'

describe 'POST api/v1/payment_results' do 
  it 'when done correctly returns 200 with success message' do
    user = create(:user)
    create(:cart_item, user: user)
    order = create(:order, user: user)

    post '/api/v1/payment_results', params: { transaction: { "code": "#{order.code}",
                                                              "status": "completed",
                                                              "error_type": "" } }
    body = response.body

    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Mensagem recebida com sucesso.'
  end

  it 'when done with incorrect identifier returns 404 with fail details' do
    user = create(:user)
    create(:cart_item, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ASDF1234')
    order = create(:order, user: user)

    post '/api/v1/payment_results', params: { transaction: { "code": "4567-QWER",
                                                            "status": "completed",
                                                            "error_type": "" } }
    body = response.body

    expect(response.status).to eq 404
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Transação desconhecida.'
  end

  it 'returns 500 if some error occurs inside the server' do
    allow(Order).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

    post '/api/v1/payment_results', params: { transaction: { "code": "4567-QWER",
                                                            "status": "completed",
                                                            "error_type": "" } }
    body = response.body

    expect(response.status).to eq 500
    expect(response.content_type).to include 'application/json'
    expect(body).to eq 'Alguma coisa deu errado, por favor contate o suporte.'
  end
end