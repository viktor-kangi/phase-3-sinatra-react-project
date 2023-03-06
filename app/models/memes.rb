class Meme < ActiveRecord::Base 
    belongs_to :user
    validates_presence_of :url, :title
    validates :title, presence: true
    validates :description, presence: true
end