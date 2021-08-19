const Pool = require('pg').Pool
const pool = new Pool({
  host: 'ec2-18-217-115-191.us-east-2.compute.amazonaws.com',
  user: 'mike',
  password:'password',
  database: 'postgres',
  port: 5432,
})


const getQuestions = (request, response) => {

  const id = request.query.product_id;
  const page = request.query.page || 1;
  const count = request.query.count || 5;

  var startingPoint = (page - 1) * count;

  var queryStr = `
      select
        questions.question_id,
        questions.question_body,
        questions.question_date,
        questions.asker_name,
        questions.question_helpfulness,
        questions.reported,
        COALESCE (json_object_agg(
          answers.answer_id, json_build_object(
            'id', answers.answer_id,
            'body', answers.body,
            'date', answers.date,
            'answerer_name', answers.answerer_name,
            'helpfulness', answers.helpfulness,
            'photos', array(
              select url from photos where photos.fkanswer_id = answers.answer_id)))
              FILTER (WHERE answers.answer_id IS NOT NULL AND answers.answer_reported = false), '{}') AS answers
      FROM questions
      LEFT JOIN answers
      ON questions.question_id = answers.fkquestion_id
      WHERE questions.product_id = $1 AND questions.reported = false
      GROUP BY questions.question_id
      offset $2 limit $3`

  pool.query(queryStr, [id, startingPoint, count], (error, results) => {
    if (error) {
      throw error;
    }
    var returnObj = {};
    returnObj.product_id = id;
    returnObj.results = results.rows;
    response.status(200).json(returnObj);
  })
};

const getAnswers = (request, response) => {

  var id = request.params.question_id;
  const page = request.query.page || 1;
  const count = request.query.count || 5;
  var startingPoint = (page - 1) * count;


  var queryStr = `
    select
      answers.answer_id,
      answers.body,
      answers.date,
      answers.answerer_name,
      answers.helpfulness,
      COALESCE(array_agg (
        json_build_object(
          'id', photos.photos_id,
          'url', photos.url
        ))
        FILTER (WHERE photos.photos_id IS NOT NULL), '{}') as photos
    FROM answers
    LEFT JOIN photos
    ON photos.fkanswer_id = answers.answer_id
    WHERE answers.fkquestion_id = $1 AND answers.answer_reported = false
    GROUP BY answers.answer_id
    offset $2 limit $3`;

  pool.query(queryStr, [id, startingPoint, count], (error, results) => {
    if (error) {
      throw error;
    }
    var returnObj = {};
    returnObj.question = id;
    returnObj.page = page;
    returnObj.count = results.rows.length;
    returnObj.results = results.rows;
    response.status(200).json(returnObj);
  })

};

const addQuestion = (request, response) => {
  const { body, name, email, product_id } = request.body;

  var queryStr = `INSERT INTO questions (product_id, question_body, asker_name, asker_email, reported, helpful, question_date) VALUES ($1, $2, $3, $4, $5, $6, current_timestamp) `
  pool.query(queryStr, [product_id, body, name, email, false, 0], (error, results) => {

    if (error) {
      throw error
    }
    response.sendStatus(204);
  })

};

const addAnswer = (request, response) => {
  const id = request.params.question_id;
  const { body, name, email, photos } = request.body;

  var insertAnswerQuery = `INSERT INTO answers (fkquestion_id, body, answerer_name, answerer_email, answer_reported, helpfulness, date) VALUES ($1, $2, $3, $4, $5, $6, current_timestamp) RETURNING answer_id
  `;

  var insertPhotosQuery = `INSERT INTO photos (fkanswer_id, url) VALUES ($1, $2)`;

  pool.query(insertAnswerQuery, [id, body, name, email, 0, 0], async (error, results) => {

    if (error) {
      throw error
    }
    var answer_id = results.rows[0].answer_id;

    for (var i = 0; i < photos.length; i++) {
      await pool.query(insertPhotosQuery, [answer_id, photos[i]], (error, results) => {
        if (error) {
          throw error
        }
      })
    }
  })
  response.sendStatus(204);
};

const markQuestionHelpful = (request, response) => {

  const id = request.params.question_id;

  var queryStr = `
    UPDATE questions
    SET question_helpfulness = question_helpfulness + 1
    WHERE question_id = $1`;

  pool.query(queryStr, [id], (error, results) => {

    if (error) {
      throw error
    }
    response.sendStatus(204);
  })
};

const reportQuestion = (request, response) => {

  const id = request.params.question_id;

  var queryStr = `
    UPDATE questions
    SET reported =  true
    WHERE question_id = $1`;

  pool.query(queryStr, [id], (error, results) => {

    if (error) {
      throw error
    }
    response.sendStatus(204);
  })


};

const markAnswerHelpful = (request, response) => {
  const id = request.params.answer_id;

  var queryStr = `
    UPDATE answers
    SET helpfulness = helpfulness + 1
    WHERE answer_id = $1`;

  pool.query(queryStr, [id], (error, results) => {

    if (error) {
      throw error
    }
    response.sendStatus(204);
  })
};

const reportAnswer = (request, response) => {
  const id = request.params.answer_id;

  var queryStr = `
    UPDATE answers
    SET answer_reported = true
    WHERE answer_id = $1`;

  pool.query(queryStr, [id], (error, results) => {

    if (error) {
      throw error
    }
    response.sendStatus(204);
  })

};


module.exports = {
  getQuestions,
  getAnswers,
  addQuestion,
  addAnswer,
  markQuestionHelpful,
  reportQuestion,
  markAnswerHelpful,
  reportAnswer
}