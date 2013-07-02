class QuestionFollower
  def self.find_by_id(id)
    follower_row = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT *
       FROM question_followers
       WHERE question_followers.id = (?)
    SQL
    follower_row.first
  end

  attr_reader :question_id, :user_id

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

end