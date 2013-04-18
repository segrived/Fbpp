class Comment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :anonymously, :mark, :posttime, :body

  MARKS = { bad: 0, neutral: 1, good: 2 }

  # Проверяемые условия
  validates :user_id, :existence => true
  validates :mark, :inclusion => { :in => MARKS.values }
  validates :body, :presence => true

  def rating
    CommentVote.where(comment_id: self.id).sum(:vote)
  end

  before_create :set_posttime

  def set_posttime
    self.posttime = Time.now
  end
end