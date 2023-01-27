class Template < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  before_save :update_location

  def update_location
    self.location =  "#{Rails.root}/tmp/#{user_id}/#{name}"
  end
end
