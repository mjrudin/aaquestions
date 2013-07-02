class QuestionLike
  def self.find_by_id(id)
    likes_row = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT *
       FROM question_likes
       WHERE question_likes.id = (?)
    SQL
    QuestionLike.new(likes_row.first)
  end

  attr_reader :question_id, :user_id

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

end