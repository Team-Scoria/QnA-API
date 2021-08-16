const express = require('express')
const app = express()
const db = require('./queries.js')
const port = 3000

app.use(express.json())
app.use(
  express.urlencoded({
    extended: true,
  })
)
app.get('/', (request, response) => {
  response.json({ info: 'Node.js, Express, and Postgres API' })
})

// app.get('/users/:userId/books/:bookId', function (req, res) {
//   res.send(req)
// })

// app.get('/qa/questions', (request, response) => {
//   response.json({ info: 'Node.js, Express, and Postgres API' })
// })

app.get('/qa/questions/', db.getQuestions);
app.get('/qa/questions/:question_id/answers', db.getAnswers);
app.post('/qa/questions', db.addQuestion)
app.post('/qa/questions/:question_id/answers', db.addAnswer);
app.put('/qa/questions/:question_id/helpful', db.markQuestionHelpful);
app.put('/qa/answers/:answer_id/helpful', db.markAnswerHelpful);
app.put('/qa/questions/:question_id/report', db.reportQuestion);
app.put('/qa/answers/:answer_id/report', db.reportAnswer);



app.listen(port, () => {
  console.log(`App running on port ${port}.`)
})