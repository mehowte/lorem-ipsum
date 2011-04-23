#!/usr/bin/env ruby

module LoremIpsum

class Generator

  def initialize(data_files = [], max_ngraph = 5)
    @letter_count = {}
    @word_lengths = {}
    @max_ngraph = max_ngraph

    data_files.each { |file| analyze(file) }
  end

  def analyze(filename)
    File.open(filename) do |file|
      while (line = file.gets)
        # todo - not handling punctuation
        line = line.strip.downcase.gsub(/[^a-z ]/, '')

        word = ""
        line.chars do |c|
          if c == ' '
            @word_lengths[word.length] ||= 0
            @word_lengths[word.length] += 1
            word = ""
          else
            word << c
            n = [@max_ngraph, word.length].min
            ngraph = word[-n..-1]

            ngraph.chars.to_a.inject(@letter_count) do |hash, char|
              hash[char] ||= { :count => 0 }
              hash[char][:count] += 1
              hash = hash[char]
            end
          end
        end
      end
    end
  end

  def generate(options = { :words => 100 })
    str = ""
    if options[:words]
      1.upto(options[:words]) do
        word = ""
        1.upto(next_word_length) do |i|
          word << next_char(word)
        end
        str << "#{word} "
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

  def next_char(prev)
    n = [@max_ngraph-1, prev.length].min
    prev_ngraph = prev[-n..-1]

    n_count = prev_ngraph.chars.to_a.inject(@letter_count) do |hash, char|
      # If we don't have statistics for this n-graph, just use the stats
      # for the (n-1)-graph
      break hash.keys.count > 3 ? hash : @letter_count if !hash[char]
      hash = hash[char]
    end.reject { |k, v| k == :count }

    num_letters ||= n_count.values.inject(0) { |s,c| s += c[:count] }
    index = rand(num_letters + 1)

    "abcdefghijklmnopqrstuvqxyz".chars do |c|
      index -= n_count[c] && n_count[c][:count] || 0
      return c if index <= 0
    end
  end

end

end

if __FILE__ == $0
  gen = LoremIpsum::Generator.new(ARGV)
  p gen.generate
end

