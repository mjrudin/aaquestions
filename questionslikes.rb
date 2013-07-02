class QuestionLike
  def self.find_by_id(id)
    likes_row = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT *
       FROM question_likes
       WHERE question_likes.id = (?)
    SQL
    QuestionLike.new(likes_row.first)
  end

  def self.likers_for_question_id(question_id)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.*
      FROM question_likes
      JOIN users
      ON question_likes.user_id = users.id
      WHERE question_likes.question_id = (?)
    SQL
    user_data.map { |user_hash| User.new(user_hash) }
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT COUNT(*)
      FROM question_likes
      WHERE question_likes.question_id = (?)
    SQL
    num_likes.first["COUNT(*)"]
  end

  def self.liked_questions_for_user_id(user_id)
    question_data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.*
      FROM question_likes
      JOIN questions
      ON question_likes.question_id = questions.id
      WHERE question_likes.user_id = (?)
    SQL
    question_data.map { |question_hash| Question.new(question_hash) }
  end

  def self.most_liked_questions(n)
    question_data = QuestionDatabase.instance.execute(<<-SQL, n)
      SELECT questions.*, COUNT(*)
      FROM question_likes
      JOIN questions
      ON question_likes.question_id = questions.id
      GROUP BY question_id
      ORDER BY COUNT(question_id) DESC
      LIMIT (?)
    SQL
    question_data.map { |question_hash| Question.new(question_hash)}
  end


  attr_reader :question_id, :user_id

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

end