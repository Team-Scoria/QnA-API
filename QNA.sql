DROP DATABASE qna;
DROP TABLE photos;
DROP TABLE answers;
DROP TABLE questions;
CREATE DATABASE qna;

CREATE TABLE questions(
  question_id SERIAL NOT NULL,
  product_id INTEGER NOT NULL,
  question_body VARCHAR(300),
  unixtimestamp BIGINT,
  asker_name VARCHAR(30),
  asker_email VARCHAR(50),
  reportedNum INTEGER,
  question_helpfulness INTEGER,
  PRIMARY KEY(question_id),
  question_date timestamp,
  reported BOOLEAN
);
COPY questions (question_id, product_id,question_body,unixtimestamp,asker_name,asker_email,reportedNum,question_helpfulness)FROM '/Users/mikeko/Downloads/questions.csv' CSV HEADER;
UPDATE questions SET question_date = (to_timestamp((SELECT unixtimestamp)/1000));
UPDATE questions SET reported = (
  CASE
    WHEN reportedNum = 1 THEN true
    WHEN reportedNum = 0 THEN false
  END
);
ALTER TABLE questions
DROP COLUMN reportedNum,
DROP COLUMN unixtimestamp;
SELECT setval(pg_get_serial_sequence('questions', 'question_id'), (SELECT MAX(question_id) FROM questions)+1);

CREATE TABLE answers(
  answer_id SERIAL,
  fkquestion_id INTEGER,
  body VARCHAR(300),
  date timestamp,
  answerer_name VARCHAR(30),
  answerer_email VARCHAR(50),
  answer_reported BOOLEAN,
  answer_reportedNum INTEGER,
  unixtimestamp BIGINT,
  helpfulness INTEGER,
  PRIMARY KEY(answer_id),
  FOREIGN KEY (fkquestion_id) REFERENCES questions (question_id)
);
COPY answers (answer_id, fkquestion_id,body,unixtimestamp,answerer_name,answerer_email,answer_reportedNum,helpfulness)FROM '/Users/mikeko/Downloads/answers.csv' CSV HEADER;
UPDATE answers SET date = (to_timestamp((SELECT unixtimestamp)/1000));
UPDATE answers SET answer_reported = (
  CASE
    WHEN answer_reportedNum = 1 THEN true
    WHEN answer_reportedNum = 0 THEN false
  END
);
ALTER TABLE answers
DROP COLUMN answer_reportedNum,
DROP COLUMN unixtimestamp;
SELECT setval(pg_get_serial_sequence('answers', 'answer_id'), (SELECT MAX(answer_id) FROM answers)+1);

CREATE TABLE photos(
  photos_id SERIAL,
  fkanswer_id INTEGER,
  url VARCHAR(200),
  PRIMARY KEY(photos_id),
  FOREIGN KEY (fkanswer_id) REFERENCES answers (answer_id)
);
COPY photos (photos_id, fkanswer_id, url)FROM '/Users/mikeko/Downloads/answers_photos.csv' CSV HEADER;
SELECT setval(pg_get_serial_sequence('photos', 'photos_id'), (SELECT MAX(photos_id) FROM photos)+1);

CREATE INDEX question_id_index ON questions (question_id);
CREATE INDEX answer_id_index ON answers (answer_id);
CREATE INDEX photos_id_index ON photos (photos_id);
CREATE INDEX answers_reported_index ON answers (answer_reported);
CREATE INDEX questions_reported_index ON questions (reported);
CREATE INDEX fkquestion_id_index ON answers (fkquestion_id);
CREATE INDEX fkanswer_id_index ON photos (fkanswer_id);
CREATE INDEX url_index ON photos (url);
CREATE INDEX product_id_index ON questions (product_id);
