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
    range_hash = Hash.new
    start = 1
    sorted_vals.each do |val|
      finish = start + val - 1
      range = (start..finish)
      start = finish + 1
      range_hash[range] = val
    end
    range_hash
  end  
  
end
