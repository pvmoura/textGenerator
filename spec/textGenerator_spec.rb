require 'spec_helper'

describe TextGenerator do
  let(:text_generator_class) { Class.new { include TextGenerator } }
  let(:words) { ["here", "are", "some", "words", "are", "they", "words"]}

  subject(:tg) { text_generator_class.new }


  it 'has a version number' do
    expect(TextGenerator::VERSION).not_to be nil
  end

  describe "#read_file_to_array" do
    before do 
      f = File.new("test.txt", "w")
      f.write("This is a test file\nHere's another line")
      f.close
    end

    let(:arr) { tg.read_file_to_array("test.txt") }
    
    it "returns an array of single words" do
      expect(arr.join(" ")).to eq("This is a test file Here's another line")
    end
    
    after(:all) { FileUtils.rm("test.txt") }
  end

  describe "#clean_text" do
    let(:cleaned_words) { tg.clean_text(["1.2asd", "ASDf", "Hello,", "123"]) }
    let(:regex) { /([^A-Za-z])/ }

    it "deletes nonalphanumeric characters" do
      cleaned_words.each do |word|
        match = regex.match(word)
        expect(match).to be nil
      end
    end

    it "makes words lowercase" do
      cleaned_words.each { |word| expect(/[[:upper:]]/.match(word)).to be nil }
    end
  end

  describe "#hist" do
    it "counts correctly" do
      histogram = tg.hist(words)
      expect(histogram).to eq({"are" => 2, "some" => 1, "words" => 2, "they" => 1, "here" => 1})
    end
  end

  describe "#get_word_count_by_frequency" do
    let(:hashstack) { {(1..1) => 1, (2..3) => 2, (4..6) => 3 } }
    
    it "finds the correct range and returns the corresponding count" do
      expect(tg.get_word_count_by_frequency(3, hashstack)).to eq(2)
    end
  end

end
