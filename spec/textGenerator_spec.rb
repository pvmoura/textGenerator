require 'spec_helper'

describe TextGenerator do
  let(:text_generator_class) { Class.new { include TextGenerator } }
  let(:words) { ["here", "are", "some", "words", "are", "they", "words"]}
  let(:data) { {"word" => 1, "right" => 1, "said" => 2, "fred" => 10} }
  
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

  describe "#values_to_frequency_range" do

    it "returns an empty hash when data is empty" do
      frequencies = tg.values_to_frequency_range({})
      expect(frequencies).to eq({})
    end

    it "returns a hash with range keys and count values" do
      frequencies = tg.values_to_frequency_range(data)
      expect(frequencies).to eq({(1..1) => 1, (2..3) => 2, (4..13) => 10} )
    end
  end

  context "when a text is generated" do
    let(:text_arr) { tg.generate_text(data, tg.values_to_frequency_range(data)) }
    
    describe "#generate_text" do

      it "has 100 words" do
        expect(text_arr.size).to eq(100)
      end
    end

    describe "#pretty_print" do
      let(:split_text) { tg.pretty_print(text_arr).split(".") }

      it "has 10 sentences" do
        print split_text
        expect(split_text.size).to eq(10)
      end

      it "has sentences with 10 words" do
        split_text.each do |sentence|
          expect(sentence.split(" ").size).to eq(10)
        end
        # text_arr.each_with_index do |word, index|
        #   expect(word).not_to be nil
        #   if index % 10
        #     expect(/\./.match(text_arr[index - 1])).not_to be nil
        #   end
        # end
      end

      it "has capitalized first words" do
        split_text.each do |sentence|
          words = sentence.split(" ")
          is_upper = /[[:upper:]]/.match(words.first[0])
          expect(is_upper).not_to be nil
        end
      end
    end
  end

end
