require "textGenerator/version"


=begin
  Call run for the main functionality:
    Continuously checks the directory where it was called for text files, which
    it reads, counts up the words in each file, and adds them to a growing
    corpus of data. Next, it picks 100 words randomly (weighted by frequency)
    and assembles them into 10 ten-word sentences, printing the to the screen 80
    characters per line.     
=end
module TextGenerator

  # Main function. On each iteration of this infinite loop, for each text file
  # in the directory, it reads in the file, scrubs the words of nonalphanumeric
  # characters, makes a histogram of word counts, merges that histogram with the
  # data that's already been seen, calculates the frequency ranges of each word,
  # and randomly generates a text weighted by word frequency that it prints to
  # the screen before dumping the text file in /data
  # Params:
  # times - Number object number of times to run the loop
  def run(times=Float::INFINITY)
    already_seen_data = {}
    1.upto(times) do
      Dir.glob("*.txt").each do |filename|
        clean_new_words = clean_text(read_file_to_array(filename))
        histogram = hist(clean_new_words)
        already_seen_data.merge!(histogram) {|k, oldv, newv| already_seen_data[k] = oldv + newv }
        ranges = values_to_frequency_range(already_seen_data)
        generated_words = generate_text(already_seen_data, ranges)
        puts print_text generated_words
        FileUtils.mv filename, "./data"
      end
    end
  end
  
  # reads the text of a file into an array of words
  # Params:
  # filename - String object representing a filename (with extension)
  def read_file_to_array(filename)
    file = File.new(filename, "r")
    arr = file.readlines.collect { |l| l.split }
    file.close
    arr.flatten
  end

  # scrubs nonalphanumeric characters
  # Params:
  # words_array - Array object of words to be cleaned
  # regex - Regex object character pattern to scrub
  def clean_text(words_array, regex=/([^A-Za-z])/)
    words_array.collect { |word| word.gsub(regex, "").downcase }
  end

  # creates a histogram from an array of words
  # Params:
  # arr - Array object of words to count
  def hist(arr)
    histogram = Hash.new(0)
    arr.each { |item| histogram[item] += 1 }
    histogram
  end

  # given a hash with ranges as keys and a number, will return the value whose
  # key is the range in which the number lies
  # Params:
  # needle - Number to find key in
  # hashstack - Hash object with ranges as keys and word counts as values
  def get_word_count_by_frequency(needle, hashstack)
    range = hashstack.select { |key, value| key.include? needle }
    hashstack[range.keys.pop]
  end
  
  # To weight random word selection, this function takes a histogram, sums all
  # the word counts and corresponds each count with a range that represents its
  # frequency in the corpus
  # Params:
  # histogram - Hash object of words and their frequencies
  def values_to_frequency_range(histogram)
    sorted_vals = histogram.values.uniq.sort
    sum = sorted_vals.reduce { |sum, curr| sum + curr }
    ranges = Hash.new
    start = 1
    sorted_vals.each do |val|
      finish = start + val - 1
      range = (start..finish)
      start = finish + 1
      ranges[range] = val
    end
    ranges
  end

  # returns an array with 100 words randomly generated weighted by frequency
  # Params:
  # wordshash - Hash object histogram
  # ranges - Hash object that corresponds word counts to frequency ranges
  def generate_text(wordshash, ranges)
    sum = wordshash.values.uniq.reduce { |sum, curr| sum + curr }
    text = []
    100.times do
      num = rand(1..sum)
      value = get_word_count_by_frequency(num, ranges)
      words = wordshash.select { |k,v| value == v }
      text << words.keys.sample
    end
    text
  end
  
  # returns a string with punctuation and proper capitalization
  # Params:
  # word_array - Array object of words
  def printify_text(word_array)
    (0..word_array.size - 1).step(10) do |index|
      word_array[index] = word_array[index].capitalize
      word_array[index - 1] = word_array[index - 1] + "."
    end
    word_array.join(" ")
  end

  # returns a string with correct punctuation and line breaks every 80 characters
  # Regex pattern matches any character up to line_width times until it reaches
  # the end of the string or a space character (so it doesn't break on words)
  # Params:
  # word_array - Array object of words
  # line_width - Number object the number of characters per line
  # delim - String object the line ending character
  def print_text(word_array, line_width=80, delim="\n")
    text = printify_text(word_array)
    text.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1" + delim)
  end

end
