require "textGenerator/version"

module TextGenerator

  def read_file_to_array(filename)
    file = File.new(filename, "r")
    arr = file.readlines.collect { |l| l.split }
    file.close
    arr.flatten
  end

  def clean_text(words_array, regex=/([^A-Za-z])/)
    words_array.collect { |word| word.gsub(regex, "").downcase }
  end

  def hist (arr)
    histogram = Hash.new(0)
    arr.each { |item| histogram[item] += 1 }
    histogram
  end

  def get_word_count_by_frequency (needle, hashstack)
    range = hashstack.select { |key, value| key.include? needle }
    hashstack[range.keys.pop]
  end
  
  def values_to_frequency_range(data)
    sorted_vals = data.values.uniq.sort
    sum = sorted_vals.reduce { |sum, curr| sum + curr }
    ranges = {}
    start = 1
    sorted_vals.each do |val|
      finish = start + val - 1
      range = (start..finish)
      start = finish + 1
      ranges[range] = val
    end
    ranges
  end

  def generate_text (wordshash, ranges)
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
  
  def wrap_line(text, line_width=80)
    text.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n")
  end
  
  def pretty_print (word_array, delim="\n")
    (0..word_array.size - 1).step(10) do |index|
      word_array[index] = word_array[index].capitalize
      word_array[index - 1] = word_array[index - 1] + "."
    end
    wrap_line(word_array.join(" "), 80) 
  end

end
