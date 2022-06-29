module ClientBalanceHelper
  def balance
    begin
      identify_number = { "registration_number": "#{current_user.identify_number}" }.as_json
      result = Faraday.get('http://localhost:4000/api/v1/clients_info', identify_number)
    
      JSON.parse(result.body)["client_info"]["balance"] if result.status == 200
    rescue
      0
    end
  end
end
