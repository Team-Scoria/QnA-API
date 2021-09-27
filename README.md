# QnA-API

Custom API built with PostgreSQL designed to handle thousands of requests for data by many users at once.

### Tech Stack
 
**Server:** Node, Express
 
**Database:** PostgreSQL


### Get questions
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

### Get answers
Returns corresponding answers given a specified question ID
```http
  GET /qa/questions/:question_id/answers
```
| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `question_id`| `number` | `ID of the question for which answers are needed` |

### Add a Question
Adds a question for the given product
```http
  POST /qa/questions
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `body`| `text` | `Text of question being asked` |
| `name`| `text` | `Username for question asker` |
| `email`| `text` | `Email address for question asker` |
| `product_id`| `number` | `Required ID of the Product for which the question is posted` |

### Add an Answer
Adds an answer for the given question
```http
  POST /qa/questions/:question_id/answers
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `question_id`| `number` | `Required ID of the question to post the answer for` |
| `body`| `text` | `Text of question being asked` |
| `name`| `text` | `Username for question asker` |
| `email`| `text` | `Email address for question asker` |
| `photos`| `[text]` | `An array of urls corresponding to images to display` |


### Mark Question as Helpful
Updates a question to show it was found helpful.
```http
  PUT /qa/questions/:question_id/helpful
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `question_id`| `number` | `Required ID of the question to update` |


### Report Question
Updates a question to show it was reported. Note, this action does not delete the question, but the question will not be returned in the above GET request.
```http
  PUT /qa/questions/:question_id/report
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `question_id`| `number` | `Required ID of the question to update` |


### Mark Answer as Helpful
Updates an answer to show it was found helpful.
```http
  PUT /qa/answers/:answer_id/helpful
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `answer_id`| `number` | `Required ID of the answer to update` |


### Report Answer
Updates an answer to show it has been reported. Note, this action does not delete the answer, but the answer will not be returned in the above GET request.
```http
  PUT /qa/answers/:answer_id/report
```

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `answer_id`| `number` | `Required ID of the answer to update` |
