require_relative 'word_counter_helper'
require_relative 'common_words'

class WordCounter
  def initialize(book = nil, number_of_results = nil)
    @book = book.to_s
    @number_of_results = number_of_results.to_i
    @bag = Bag.new
    @results = nil
    raise "\n\n\tPlease enter a valid input file path!" +
          "\n\tUsage: ruby word_count.rb <book_filename> <number_of_results>\n\n" unless File.exists?(@book)
  end

  def read
    File.readlines(@book).each do |line|
      words = line.split(/\W+/).map(&:downcase)
      @bag.add(words)
    end
  end

  def calculate
    @results = @bag.count.delete_if do |word, _|
      CommonWords.list.include?(word) || word !~ /\D/
    end.sort_by { |word, count| -count }
    @results = @results.first(@number_of_results) if @number_of_results > 0
  end

  def output
    prefix = File.basename("#{@book}", '.txt') + '_'
    suffix = @number_of_results > 0 ? "_#{@number_of_results}" : ''
    output_file = "#{prefix}word_count#{suffix}.txt"
    File.delete(output_file) if File.exists?(output_file)

    File.open(output_file, 'w') do |f|
      @results.each do |word, count|
        f << "#{word}: #{count}\n"
      end
    end
  end
end

word_counter = WordCounter.new(ARGV[0], ARGV[1])
word_counter.read
word_counter.calculate
word_counter.output
