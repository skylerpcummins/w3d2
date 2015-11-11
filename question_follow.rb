require 'sqlite3'
require_relative 'manifest.rb'

class QuestionFollow
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id,  @user_id, @question_id =
    options.values_at('id', 'user_id', 'question_id')
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    raise "multiple entries found" if data.count > 1

    data.map {|datum| QuestionFollow.new(datum)}.first
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_follows ON questions.id = question_follows.question_id
    WHERE
      question_follows.user_id = ?
    SQL

    data.map { |datum| Question.new(datum) }
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL

    data.map {|datum| User.new(datum)}
  end

  def self.most_followed_questions
    
  end
end
