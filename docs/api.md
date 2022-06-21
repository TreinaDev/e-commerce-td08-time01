# API

## Enviando resultado de processamento de pagamento
![POST](https://img.shields.io/badge/-POST-blue "POST") `/api/v1/payment_results`  
  
Ao gerar um pedido, um código único é atrelado a ele e uma requisição de transação é enviada para o time que processa pagamentos. O pedido estará em pendência de pagamento até que uma resposta de aprovação ou recusa seja enviada por esta URL.  

### Payload
```
transaction: { 
  "code": "4567-QWER",
  "status": "completed",
  "error_type": "" 
}
```
| parâmetro | descrição | valores reconhecidos | 
| -------- | -------- |  -------- | 
| `code` | código repassado na geração do pedido | código alfanumérico de 8 caracteres separados por um hífen no meio | 
| `status` | indica se houve aprovação ou recusa da transação | `'completed'` ou `'rejected'` | 
| `error_type` | motivo de recusa do pedido | `'insufficent_funds'` ou `'fraud_warning'` | 

### Sucesso
![200: Ok](https://img.shields.io/badge/Code:%20200-OK-green "200: Ok")  
`"Mensagem recebida com sucesso."`

### Falha
![404: Not found](https://img.shields.io/badge/Code:%20404-NOT%20FOUND-red "404: Not found")  
O código da transação não foi localizado como sendo de nenhum pedido.  
`"Transação desconhecida."`  
  
![500: Internal Server Error](https://img.shields.io/badge/Code:%20500-INTERNAL%20SERVER%20ERROR-red "500: Internal Server Error")  
Algum erro aconteceu no servidor da aplicação.  
`"Alguma coisa deu errado, por favor contate o suporte."`  