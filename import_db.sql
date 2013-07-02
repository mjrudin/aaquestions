CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL

);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)

);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(reply_id) REFERENCES replies(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)


);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)

);


INSERT INTO users (fname,lname)
  VALUES ('Sid', 'Raval'), ('Matt', 'Rudin');

INSERT INTO questions (title,body,user_id)
  VALUES ('Does this work?','Im just really curious.',1),
         ('Lunchtime','Whats for lunch?',2),('Dinner','Whats for dinner?',2);

INSERT INTO question_followers (question_id,user_id)
  VALUES (1,2), (2,1);

INSERT INTO replies (body,reply_id,user_id,question_id)
  VALUES ('Probably chipotle.',NULL,1,2), ('Not feeling it.',1,2,2);

INSERT INTO question_likes (question_id,user_id)
  VALUES (1,2);