require 'sqlite3'
require_relative 'manifest.rb'

class Reply
  attr_accessor :id, :body, :question_id, :parent_id, :user_id

  def initialize(options)
    @id, @body, @question_id, @parent_id, @user_id =
    options.values_at('id', 'body', 'question_id', 'parent_id', 'user_id')
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    data.map { |el| Reply.new(el) }
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def author
    User.find_by_id(user_id)
  end

  def child_replies
    related_replies = self.question.replies
    related_replies.select {|reply| reply.parent_id == id}
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    raise "multiple entries found" if data.count > 1

    data.map {|datum| Reply.new(datum)}.first
  end

  def question
    Question.find_by_id(question_id)
  end


end
