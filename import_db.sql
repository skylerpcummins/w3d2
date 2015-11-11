DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

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

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Skyler', 'Cummins'),
  ('Jesse', 'Hulcher'),
  ('Jeff', 'Fiddler'),
  ('Kush', 'Patel');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('babies', 'how are babies made?', (SELECT id FROM users WHERE fname = 'Skyler')),
  ('sleep', 'when do i get to go to sleep?', (SELECT id FROM users WHERE fname = 'Jesse'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Skyler'), (SELECT id FROM questions WHERE title = 'sleep')),
  ((SELECT id FROM users WHERE fname = 'Jesse'), (SELECT id FROM questions WHERE title = 'babies'));

INSERT INTO
  replies (body, question_id, parent_id, user_id)
VALUES
  ('Babies are brought by storks!', (SELECT id FROM questions WHERE title = 'babies'),
  NULL, (SELECT id FROM users WHERE fname = 'Jeff')),
  ('NEVER!', (SELECT id FROM questions WHERE title = 'sleep'),
  NULL, (SELECT id FROM users WHERE fname = 'Jeff')),
  ('When you graduate, loser...', (SELECT id FROM questions WHERE title = 'sleep'),
  NULL, (SELECT id FROM users WHERE fname = 'Kush')),
  ('Dont call him a loser, loser!', (SELECT id FROM questions WHERE title = 'sleep'),
  3, (SELECT id FROM users WHERE fname = 'Jeff'));

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Kush'), (SELECT id FROM questions WHERE title = 'sleep')),
  ((SELECT id FROM users WHERE fname = 'Kush'), (SELECT id FROM questions WHERE title = 'babies'));
