# API

## Enviando resultado de processamento de pagamento
![PATCH](https://img.shields.io/badge/-POST-blue "PATCH") `/api/v1/payment_results`  
  
Ao gerar um pedido, um código único é atrelado a ele e uma requisição de transação é enviada para o time que processa pagamentos. O pedido estará em pendência de pagamento até que uma resposta de aprovação ou recusa seja enviada por esta URL.  

### Payload
```json
{
  "transaction": { 
    "code": "4567-QW4R",
    "status": "completed",
    "error_type": "" 
  }
}
```
| parâmetro | descrição | valores reconhecidos | 
| -------- | -------- |  -------- | 
| `code` | código repassado na geração do pedido | código alfanumérico de 8 caracteres separados por um hífen no meio | 
| `status` | indica se houve aprovação ou recusa da transação | `'approved'` ou `'canceled'` | 
| `error_type` | motivo de recusa do pedido | `''`, `'insufficient_funds'` ou `'fraud_warning'` | 

### Sucesso
![200: Ok](https://img.shields.io/badge/Code:%20200-OK-green "200: Ok")  
Retorna `"Mensagem recebida com sucesso."`  
  
### Falha
![404: Not found](https://img.shields.io/badge/Code:%20404-NOT%20FOUND-red "404: Not found")  
Retorna `"Transação desconhecida."` porque o código da transação não foi localizado como pertencendo a nenhum pedido.  
   
     
![422: Unprocessable entity](https://img.shields.io/badge/Code:%20422-UNPROCESSABLE%20ENTITY-red "422: Unprocessable entity")  
Retorna `"Status inválido."` quando conteúdo de status não é um valor reconhecido.  
    
Retorna `"O tipo de erro não pode ficar em branco quando a transação foi recusada (status: "canceled")."` quando um status "canceled" é acompanhado de um "error_type" vazio (`''`).  
   
     
![500: Internal Server Error](https://img.shields.io/badge/Code:%20500-INTERNAL%20SERVER%20ERROR-red "500: Internal Server Error")  
Retorna `"Alguma coisa deu errado, por favor contate o suporte."` porque houve um erro dentro do servidor da aplicação.  