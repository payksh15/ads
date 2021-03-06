class Announcement < ActiveRecord::Base
  attr_accessible :content, :ad_id
  belongs_to :user
  belongs_to :ad
  validates :content, :ad_id, presence: true
  default_scope order: 'announcements.created_at DESC'
end
