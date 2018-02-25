class Task < ActiveRecord::Base
  belongs_to :user
  validates :status, :inclusion => { :in => ['Active', 'Complete'], message: 'Must be Active/Completed' } 
end
