class QuestionFollower
  def self.find_by_id(id)
    follower_row = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT *
       FROM question_followers
       WHERE question_followers.id = (?)
    SQL

    QuestionFollower.new(follower_row.first)
  end

  #Users that follow a particular question
  def self.followers_for_question_id(question_id)
    User.followers_for_question_id(question_id)
  end

  def self.most_followed_questions(n)
    question_data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT question_id, COUNT(question_id)
      FROM question_followers
      GROUP BY question_id
      ORDER BY COUNT(question_id) DESC
      LIMIT (?)
    SQL
    question_data.map { |question_hash| Question.new(question_hash) }
  end

  #Questions that a user follows
  def self.followed_questions_for_user_id(user_id)
    questions_data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.*
      FROM question_followers
      JOIN questions
      ON questions.id = question_followers.question_id
      WHERE question_followers.user_id = (?)
    SQL
    questions_data.map { |question_hash| Question.new(question_hash) }
  end

  attr_reader :question_id, :user_id

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

end