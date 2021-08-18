DROP DATABASE test;
DROP TABLE photos;
DROP TABLE answers;
DROP TABLE questions;
CREATE DATABASE test;

CREATE TABLE questions(
  questions_id SERIAL NOT NULL,
  product_id INTEGER NOT NULL,
  body VARCHAR(300),
  unixtimestamp BIGINT,
  asker_name VARCHAR(30),
  asker_email VARCHAR(50),
  reportedNum INTEGER,
  helpful INTEGER,
  PRIMARY KEY(questions_id),
  date_written timestamp,
  reported BOOLEAN
);


CREATE TABLE answers(
  answers_id SERIAL,
  fkquestions_id INTEGER,
  answer_body VARCHAR(300),
  date_written timestamp,
  answerer_name VARCHAR(30),
  answerer_email VARCHAR(50),
  answer_reported BOOLEAN,
  answer_helpful INTEGER,
  unixtimestamp BIGINT,
  PRIMARY KEY(answers_id),
  FOREIGN KEY (fkquestions_id) REFERENCES questions (questions_id)
);


CREATE TABLE photos(
  photos_id SERIAL,
  fkanswers_id INTEGER,
  url VARCHAR(200),
  PRIMARY KEY(photos_id),
  FOREIGN KEY (fkanswers_id) REFERENCES answers (answers_id)
);


INSERT INTO questions (product_id,body,asker_name,asker_email,helpful,reported) values (1000, 'whats up?', 'mike',
'mike@mike.com', 1, false);
INSERT INTO questions (product_id,body,asker_name,asker_email,helpful,reported) values (1000, 'how much is it?', 'sam',
'sam@mike.com', 0, false);
INSERT INTO questions (product_id,body,asker_name,asker_email,helpful,reported) values (1000, 'does it have wifi?', 'tom',
'tom@mike.com', 0, false);
INSERT INTO questions (product_id,body,asker_name,asker_email,helpful,reported) values (1003, 'what does it smell like?', 'linda',
'linda@mike.com', 1, false);
INSERT INTO questions (product_id,body,asker_name,asker_email,helpful,reported) values (1005, 'what does it TASTE like?', 'MILDEW',
'linda@mike.com', 1, false);


INSERT INTO answers (fkquestions_id,answer_body,answerer_name,answerer_email,answer_reported,answer_helpful) values (1, 'not much!', 'hannah',
'hannah@mike.com', false, 0);
INSERT INTO answers (fkquestions_id,answer_body,answerer_name,answerer_email,answer_reported,answer_helpful) values (1, 'terrible!', 'lay',
'lays@mike.com', false, 0);
INSERT INTO answers (fkquestions_id,answer_body,answerer_name,answerer_email,answer_reported,answer_helpful) values (1, 'great!', 'cheetos',
'cheeto@mike.com', false, 0);
INSERT INTO answers (fkquestions_id,answer_body,answerer_name,answerer_email,answer_reported,answer_helpful) values (2, 'a milli', 'tiger',
'tiger@mike.com', false, 0);
INSERT INTO answers (fkquestions_id,answer_body,answerer_name,answerer_email,answer_reported,answer_helpful) values (3, 'of course', 'grapes',
'grapes@mike.com', false, 1);
INSERT INTO answers (fkquestions_id,answer_body,answerer_name,answerer_email,answer_reported,answer_helpful) values (4, 'trash', 'walnut',
'walnut@mike.com', false, 1);

INSERT INTO photos (fkanswers_id, url) values (1, 'https://images.unsplash.com/photo-1530519729491-aea5b51d1ee1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1651&q=80');
INSERT INTO photos (fkanswers_id, url) values (1, 'https://images.unsplash.com/photo-1511127088257-53ccfcc769fa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=30');
INSERT INTO photos (fkanswers_id, url) values (1, 'https://images.unsplash.com/photo-1500603720222-eb7a1f997356?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1653&q=20');
INSERT INTO photos (fkanswers_id, url) values (2, 'https://images.unsplash.com/photo-1500603720222-eb7a1f997356?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1653&q=20');
