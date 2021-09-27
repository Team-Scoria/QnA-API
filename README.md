# QnA-API

Custom API built with PostgreSQL designed to handle thousands of requests for data by many users at once.

#### SQL Schema
![](https://i.imgur.com/Qh47Vbp.png) 

### Tech Stack
 
**Server:** Node, Express
 
**Database:** PostgreSQL


### Get all questions
Returns questions, corresponding answers, and photos associated to each answers. (default 5 questions per request).
Can pass in request parameters to change the number of returned questions and/or specify which page to retrieve data from
```http
  GET /qa/questions
```

| Parameter   | Type     | Description                       |
| :---------- | :------- | :-------------------------------- |
| `product_id`| `number` | `product id` |
| `page`| `number` | `page number` |
| `count` | `number` | `number of products per page` |

### Get product info
Returns specific product information given a specified product ID
```http
  GET /products/:product_id
```
| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `product_id`| `number` | `information about a product` |

### Get related products
Returns all related products based on the specified product ID
```http
  GET /products/:product_id/related
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `product_id`| `number` | `information about a product` |

### Get styles for product
Returns all of the different styles of the specified product ID
```http
  GET /products/:product_id/styles
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `product_id`| `number` | `information about a product` |
