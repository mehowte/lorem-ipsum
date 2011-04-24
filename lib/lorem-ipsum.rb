module LoremIpsum

class Generator

  def initialize(data_files = [], opts = { :max_ngraph => 3 })
    @letter_count = { :count => 0 }
    @max_ngraph = opts[:max_ngraph]

    data_files.each { |file| analyze(file) }
  end

  def analyze(filename)
    File.open(filename) do |file|
      while (line = file.gets)
        # todo - not handling punctuation
        line = line.strip.downcase.gsub(/[^a-z ]/, '') << ' '

        word = "^"
        line.chars do |c|
          word << c
          n = [@max_ngraph, word.length].min
          ngraph = word[-n..-1]

          ngraph.chars.inject(@letter_count) do |hash, char|
            hash[char] ||= { :count => 0 }
            hash[char][:count] += 1
            hash = hash[char]
          end

          if c == ' '
            word = "^"
          end
        end
      end
    end
  end

  def generate(options = { :words => 100 })
    str = ""
    if options[:words]
      to_next_sentence = rand(10) + 5
      start_of_sentence = true
      1.upto(options[:words]) do |i|
        word = next_word
        if start_of_sentence
          word.capitalize!
          start_of_sentence = false
        end

        to_next_sentence -= 1
        if to_next_sentence == 0 || i == options[:words]
          word.gsub!(/ /,'. ')
          to_next_sentence = rand(10) + 5
          start_of_sentence = true
        end
        
        str << word
      end
    end

    str
  end

  def next_word
    word = "^"
    word << next_char(word) while word[-1..-1] != ' '
    word[1..-1]
  end

  def next_char(prev)
    # Need to make sure our words don't get too long. Not everyone is Charles
    # Dickens, even in fake-Latin land. These parameters seem to look nice,
    # but salt to taste.
    return ' ' if prev.length > 4 && rand(9 + prev.length) < prev.length

    n = [@max_ngraph-1, prev.length].min
    prev_ngraph = prev[-n..-1]

    # If we don't have statistics for this n-graph, just use the stats
    # for the (n-1)-graph
    n_count = nil
    until n_count
      n_count = prev_ngraph.chars.inject(@letter_count) do |hash, char|
        break if ! hash[char]
        hash = hash[char]
      end
      prev_ngraph = prev_ngraph[1..-1]

      n_count = @letter_count if ! prev_ngraph
    end
    n_count = n_count.reject { |k,v| k == :count || prev.empty? && k == ' ' }

    num_letters ||= n_count.values.inject(0) { |s,c| s += c[:count] }
    index = rand(num_letters + 1)

    "abcdefghijklmnopqrstuvqxyz ".chars do |c|
      index -= n_count[c] && n_count[c][:count] || 0
      return c if index <= 0
    end
  end

end

end

