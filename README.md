# Republic Job application exercise

## setup

1. setup database and dependencies

```
bundle
rails db:setup // This should run the seeds
// In case there are no records run:
// rails db:seed
```

2. Run server

```
rails s
```


## API REST endpoints

__Postman collection included:__ [postman collection](Republic\ Exercise.postman_collection.json)

### Authentication

| Implement HTTP basic authentication for API endpoints. Ensure only authenticated users can access the API.


__Basic Auth:__

- username: `test`
- password: `password`


### Get all entities

`GET /business_entities`

```bash
curl --location 'localhost:3000/business_entities' \
--header 'Authorization: Basic dGVzdDpwYXNzd29yZA=='
```

example response:

```json
{
    "data": [
        {
            "id": 1,
            "name": "Acme ltd",
            "share_supply": 100,
            "sold_supply": 30,
            "created_at": "2025-02-18T21:42:50.720Z",
            "updated_at": "2025-02-18T21:42:50.809Z",
            "business_owner_id": 1
        },
        // ...
    ]
}
```

__Search parameters:__

`GET /business_entities?[search_query]`

- remaining_supply: `true` | `false`
- owner_id: `integer`

example:

| Buyers should be able to view a list of businesses with available shares.

```bash
curl --location 'localhost:3000/business_entities?remaining_supply=true' \
--header 'Authorization: Basic dGVzdDpwYXNzd29yZA=='
```

## Get entity and orders

`GET business_entities/:id`

| Buyers should be able to view the history of shares sold for a specific business, including quantity and price.

```bash
curl --location 'localhost:3000/business_entities/1' \
--header 'Authorization: Basic dGVzdDpwYXNzd29yZA=='
```

__Example response:__

```json
{
    "data": {
        "business_entity": {
            "id": 1,
            "name": "Acme ltd",
            "share_supply": 100,
            "sold_supply": 30,
            "created_at": "2025-02-18T21:42:50.720Z",
            "updated_at": "2025-02-18T21:42:50.809Z",
            "business_owner_id": 1
        },
        "orders": [
            {
                "id": 5,
                "buyer_id": 1,
                "business_entity_id": 1,
                "shares": 50,
                "price_per_share": 50,
                "executed": false,
                "created_at": "2025-02-18T21:42:50.769Z",
                "updated_at": "2025-02-18T21:42:50.769Z"
            },
            // ...
        ]
    }
}
```

##  Orders

### List orders:

| Owners should be able to view buy orders with details such as buyer's username, quantity, and price.

`GET /orders`

```bash
curl --location 'localhost:3000/orders' \
--header 'Authorization: Basic dGVzdDpwYXNzd29yZA=='
```

_example response:_

```json
{
    "data": [
        {
            "id": 1,
            "buyer_id": 1,
            "business_entity_id": 3,
            "shares": 10,
            "price_per_share": 10,
            "executed": false,
            "created_at": "2025-02-18T21:42:50.761Z",
            "updated_at": "2025-02-18T21:42:50.761Z"
        },
    ]
}
```

__Search parameters:__

`GET /orders?[search_query]`

- business_entity_id: integer
- buyer_id: integer
- owner_id: integer
- sort_by: included_in?: `[created_at shares price_per_share]`
- sort_order: included_in?: `[asc desc]`

example:

```bash
curl --location 'localhost:3000/orders?sort_by=price_per_share&sort_order=desc&business_entity_id=2' \
--header 'Authorization: Basic dGVzdDpwYXNzd29yZA=='
```

- [ ] TODO: add buyer's username in the order's payload

### Create order

| Buyers should be able to place a buy order with a specified quantity and price.

`POST /orders`

```bash
curl --location 'localhost:3000/orders' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic dGVzdDpwYXNzd29yZA==' \
--data '{
    "order": {
        "buyer_id": 1, 
        "business_entity_id": 1, 
        "shares": 10, 
        "price_per_share": 100 
    }
}'
```

_example response:_

```json
{
    "data": {
        "id": 14,
        "buyer_id": 1,
        "business_entity_id": 1,
        "shares": 10,
        "price_per_share": 100,
        "executed": false,
        "created_at": "2025-02-19T00:33:05.650Z",
        "updated_at": "2025-02-19T00:33:05.650Z"
    }
}
```

### Confirm/execute Order:

| Owners should be able to accept or reject buy orders.

`PATCH /orders/:id/execute`

```bash
curl --location --request PATCH 'localhost:3000/orders/14/execute' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic dGVzdDpwYXNzd29yZA=='
--data ''
```

_Example response:_

```json
{
    "data": {
        "executed": true,
        "buyer_id": 1,
        "business_entity_id": 1,
        "shares": 10,
        "price_per_share": 100,
        "id": 14,
        "created_at": "2025-02-19T00:33:05.650Z",
        "updated_at": "2025-02-19T00:40:06.827Z"
    }
}
```

### Reject order

- [ ] TODO



## To be considered but not to be implemented:

### What would be required if we allowed for multiple currencies?

1. Store currency information alongside each amount:
Each currency column should be associated with its corresponding currency code (e.g., USD, EUR, GBP). A good example of handling this is the RubyMoney - Money-Rails gem, which simplifies storing and managing multi-currency data in Rails applications.

2. Regularly sync exchange rates:
To ensure accurate conversions, integrate with a reliable exchange rate data provider (e.g., Open Exchange Rates, Fixer.io) and regularly update the rates in your system.

3. Perform conversions when needed:
Implement a mechanism to convert amounts between currencies dynamically, based on the latest exchange rates, whenever a transaction or display requires it.

### How could the buyer pay for the shares? 

There are several payment options available, depending on the business's needs and the buyer's preferences:

1. Traditional payment gateways:
Integrate with popular payment providers like Stripe, PayPal, or Square, which support multiple currencies and offer seamless payment processing.

2. Blockchain-based payments:
As an alternative, consider using blockchain technology for payments, which can provide decentralized, secure, and fast transactions, especially for international buyers.

3. Bank transfers or wire payments:
For larger transactions, direct bank transfers could be an option, though they may involve longer processing times and higher fees.

### A wallet representing each currency? A single wallet? Currency conversion?

The choice depends on the level of control and complexity the business wants to manage:

1. Simplest solution:
Maintain accounting records for each buyer, order, and business transaction, tracking payments in the company's primary account. Currency conversions can be handled at the time of payment or refund.

2. Multi-currency wallets:
If the business operates in multiple currencies frequently, consider creating separate wallets for each currency to simplify tracking and reduce conversion costs.

3. Single wallet with conversions:
Use a single wallet and handle currency conversions dynamically. This approach requires robust exchange rate management and may incur conversion fees.

### How could be some of the pitfalls if the business owner rejected the purchase?

1. Exchange rate fluctuations:
If the refund is processed in a different currency, the exchange rate at the time of refund may differ from the original purchase rate. To ensure fairness, refunds should be issued in the original currency or at the original exchange rate.

2. Transaction costs:
Refunds may incur additional fees, such as currency conversion fees or transfer costs. These should be clearly communicated to the buyer and accounted for in the refund process.

3. Customer dissatisfaction:
Rejecting a purchase without clear communication or a smooth refund process can lead to negative customer experiences. Ensure transparency and provide timely updates to the buyer.

### Conclusion

All of the questions and challenges raised are technically addressable, but each solution comes with its own set of trade-offs. These trade-offs may include:

Development costs and complexity: Implementing multi-currency support, payment gateways, or wallet systems requires significant development effort and ongoing maintenance.

Operational inefficiencies: Managing multiple currencies, exchange rates, and payment methods can introduce complexity and potential inefficiencies in the system.

Additional costs: Currency conversions, transaction fees, and third-party service integrations can incur extra expenses that need to be accounted for.

It’s essential to carefully evaluate these trade-offs and discuss them with stakeholders to ensure the chosen solutions align with the business's goals, budget, and technical capabilities. By balancing these factors, the business can implement a system that meets its needs while minimizing unnecessary complexity and cost.

