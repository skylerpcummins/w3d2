require 'sqlite3'
require_relative 'manifest.rb'

class Question
  attr_accessor :id, :title, :body, :user_id

  def initialize(options)
    @id, @title, @body, @user_id =
    options.values_at('id', 'title', 'body', 'user_id')
  end

  def self.find_by_title(title)
    data = QuestionsDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL
    data.map { |something| Question.new(something) }
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    data.map { |hello| Question.new(hello) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
         *
      FROM
        questions
      WHERE
        id = ?
    SQL

    raise "multiple entries found" if data.count > 1

    data.map { |whatever| Question.new(whatever) }.first
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def author
    User.find_by_id(user_id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end
end












#
