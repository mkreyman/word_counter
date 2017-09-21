module Enumerable
  def to_histogram
    inject(Hash.new(0)) { |h, x| h[x] += 1; h}
  end
end

class Bag
  def initialize
    @bag_of_objects = []
  end

  def add(object)
    @bag_of_objects << object
  end

  def items
    @bag_of_objects.flatten
  end

  def count
    items.to_histogram
  end
end