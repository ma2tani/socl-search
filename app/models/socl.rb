class Socl < ApplicationRecord
  # プロパティの設定
  attr_accessor :name, :title, :uploadTime, :plays, :link, :postedTime, :image

  def initialize(name, title, uploadTime, plays, link, postedTime, image)
    @name = name
    @title = title   
    @uploadTime = uploadTime
    @plays = plays
    @link = link
    @postedTime = postedTime
    @image = image
  end
end
