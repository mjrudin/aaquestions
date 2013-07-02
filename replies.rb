class Reply
  def self.find_by_id(id)
    reply_row = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT *
       FROM replies
       WHERE replies.id = (?)
    SQL
    reply_row.first
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
       SELECT *
       FROM replies
       WHERE replies.question_id = (?)
    SQL
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL,user_id)
      SELECT *
      FROM replies
      WHERE replies.user_id = (?)
    SQL
  end

  attr_reader :body, :reply_id, :question_id

  def initialize(options)
    @id = options["id"]
    @body = options["body"]
    @reply_id = options["reply_id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

  #Who wrote this reply?
  def author
    User.find_by_id(@user_id)
  end

  #What question is this replying to?
  def question
    Question.find_by_id(@question_id)
  end

  #What reply, if any, is this a reply to?
  def parent_reply
    # Error handling IF @reply_id is nil
    Reply.find_by_id(@reply_id)
  end

  #What replies reply to this reply
  def child_replies
    children = QuestionsDatabase.instance.execute(<<-SQL,@id)
      SELECT *
      FROM replies
      WHERE replies.reply_id = (?)
    SQL
  end

end