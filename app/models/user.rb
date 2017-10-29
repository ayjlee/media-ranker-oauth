class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work
  has_many :works

  validates :username, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    user = User.new uid: auth_hash['uid'], provider: auth_hash['provider'], username: auth_hash['info']['nickname'], email: auth_hash['info']['email']

    user.save ? user : nil

  end
end
