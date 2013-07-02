require 'singleton'
require 'sqlite3'
require './questions.rb'
require './users.rb'
require './questionfollowers.rb'
require './replies.rb'
require './questionslikes.rb'


class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super("aaquestions.db")

    self.results_as_hash = true
    self.type_translation = true
  end
end

