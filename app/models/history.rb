class History < ApplicationRecord
  # プロパティの設定
  attr_accessor :name, :searchName, :searchTime, :searchUrl, :total, :image
  
  def initialize(name, searchName, searchTime, searchUrl, total, image)
    @name = name
    @searchName = searchName   
    @searchTime = searchTime
    @searchUrl = searchUrl
    @total = total
    @image = image
  end
end
