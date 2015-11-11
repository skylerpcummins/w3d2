require 'sqlite3'
require_relative 'manifest.rb'

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id, @user_id, @question_id =
    options.values_at('id', 'user_id', 'question_id')
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    raise "multiple entries found" if data.count > 1

    data.map {|datum| QuestionLike.new(datum)}.first
  end
end
