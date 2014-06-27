class Cuisine
  attr_accessor :category, :type

  def set_cuisine_type(type)
    puts @type
    @type=type
  end

  private
  def set_cuisine_category(cat)
    @category=cat
    puts @category
  end



end

cuisine = Cuisine.new

#call the traditional way
cuisine.set_cuisine_type(:vegan)
puts cuisine.type

#private methods cannot be called with an explicit receiver
#However they can be called with a send.

# cuisine.set_cuisine_category(:italian)
# puts cuisine.category

# However it is possible to access a private method via a send!!!!!
if cuisine.respond_to?(:set_cuisine_category)
  cuisine.send(:set_cuisine_category, :italian)
end
