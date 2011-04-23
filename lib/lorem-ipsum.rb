#!/usr/bin/env ruby

module LoremIpsum

class Generator

  def initialize(data_files = [])
    @letter_count = {}
    @word_lengths = {}

    data_files.each { |file| analyze(file) }
  end

  def analyze(filename)
    File.open(filename) do |file|
      while (line = file.gets)
        # todo - not handling punctuation
        line = line.strip.downcase.gsub(/[^a-z ]/, '')

        word_length = 0
        line.chars do |c|
          if c == ' '
            @word_lengths[word_length] ||= 0
            @word_lengths[word_length] += 1
            word_length = 0
          else
            @letter_count[c] ||= 0
            @letter_count[c] += 1
            word_length += 1
          end
        end
      end
    end
  end

  def generate(options = { :words => 100 })
    str = ""
    if options[:words]
      1.upto(options[:words]) do
        1.upto(next_word_length) do |i|
          str << next_char
        end
        str << " "
      end
    end

    str
  end

  def next_word_length
    @num_words ||= @word_lengths.values.inject(:+)
    index = rand(@num_words + 1)  # rand is fine. We don't need to generate
                                  # cryptographically secure lorem ipsum texts
                                  # for the military, here.
    length = 1
    while index > 0
      index -= @word_lengths[length] || 0
      length += 1
    end
    length
  end

  def next_char
    @num_letters ||= @letter_count.values.inject(:+)
    index = rand(@num_letters + 1)

    "abcdefghijklmnopqrstuvqxyz".chars do |c|
      index -= @letter_count[c] || 0
      return c if index <= 0
    end
  end

end

end

if __FILE__ == $0
  gen = LoremIpsum::Generator.new(ARGV)
  p gen.generate
end

