class Question
  def self.find_by_id(id)
    # ? gets replaced with passed in id
    # Or {:id => id} then replace (?) with :id
    question_row = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT *
       FROM questions
       WHERE questions.id = (?)
    SQL
    Question.new(question_row.first)
  end

  def self.find_by_author_id(author_id)
    questions_data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT *
      FROM questions
      WHERE questions.user_id = (?)
    SQL

    questions_data.map { |question_hash| Question.new(question_hash) }

  end

  attr_reader :title, :body, :user_id

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end

  #Who wrote this question?
  def author
    User.find_by_id(@user_id)
  end

  #What replies are to this question
  def replies
    Reply.find_by_question_id(@id)
  end

end
