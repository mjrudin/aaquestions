#sid = User.find_by_id(1)
#You can't call a private instance method from a class method. Sadness.
class User
  def self.followers_for_question_id(question_id)
    follower_data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.*
      FROM question_followers
      JOIN users
      ON question_followers.user_id = users.id
      WHERE question_followers.question_id = (?)
    SQL
    follower_data.map do |follower_hash|
      User.private_new(follower_hash)
    end
  end

  def self.find_by_id(id)
    user_row = QuestionsDatabase.instance.execute(
      QuestionsDatabase.simple_sql('users','id'),id
    )

    return nil if user_row.first.nil?
    User.private_new(user_row.first)

  end

  def self.find_by_name(fname,lname)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE users.fname = (?) AND users.lname = (?)
    SQL
    User.private_new(user_data.first)
  end


  attr_accessor :fname, :lname

  def initialize(options = {})
    @fname = options["fname"]
    @lname = options["lname"]

  end

  #What questions did this user write?
  def authored_questions
    Question.find_by_author_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  #What replies did this user write?
  def authored_replies
    Replies.find_by_user_id(@id)
  end

  #What questions does this user follow?
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  #Avg number of likes for a user's questions
  def average_karma
    average = QuestionsDatabase.instance.execute(<<-SQL,@id,@id)
      SELECT (CASE
              WHEN numquestions.questions = 0
              THEN NULL
              ELSE
              numlikes.likes/numquestions.questions
              END) avg
      FROM
      ( SELECT COUNT(*) likes
        FROM question_likes
        WHERE question_likes.user_id = (?) ) numlikes
      CROSS INNER JOIN
      ( SELECT COUNT(*) questions
        FROM questions
        WHERE questions.user_id = (?) ) numquestions
      SQL
      average["avg"]
  end

  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL,@fname,@lname)
      INSERT INTO users (fname,lname)
      VALUES (?,?)
      SQL
      private_set_id(QuestionsDatabase.instance.execute(
      "SELECT last_insert_rowid()")[0]['last_insert_rowid()'])
    else
      QuestionsDatabase.instance.execute(<<-SQL,@fname,@lname,@id)
      UPDATE users
      SET fname=(?), lname=(?)
      WHERE users.id=(?);
      SQL
    end
  end

  protected
  def self.private_new(options)
    user = User.new("fname" => options["fname"],"lname" => options["lname"])
    user.send(:private_set_id,options["id"])
    user
  end

  def private_set_id(id)
    @id = id
  end
end

