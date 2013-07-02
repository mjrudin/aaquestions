#sid = User.new(User.find_by_id(1))
class User
  def self.find_by_id(id)
    user_row = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM users
      WHERE users.id = (?)
    SQL
    User.new(user_row.first)
  end

  def self.find_by_name(fname,lname)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE users.fname = (?) AND users.lname = (?)
    SQL
    User.new(user_data.first)
  end

  attr_reader :fname, :lname

  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  #What questions did this user write?
  def authored_questions
    Question.find_by_author_id(@id)
  end

  #What replies did this user write?
  def authored_replies
    user_replies = Replies.find_by_user_id(@id)
  end

end