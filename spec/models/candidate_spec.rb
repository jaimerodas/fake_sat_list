require 'pathname'
require './models/candidate'

RSpec.describe Candidate do
  before(:all) do
    @candidate = Candidate.new
    @count = @candidate.count
  end

  after(:all) do
    Candidate.destroy_all
  end

  describe '#initialize' do
    it 'should return an id and count' do
      expect(@candidate.id).to be_a String
      expect(@candidate.count).to be_an Integer
    end

    it 'should create a file with the id as a name' do
      file = Pathname.new("candidates/#{@candidate.id}")
      expect(file.exist?).to be true
    end

    it 'should have an array of timestamps called facturas' do
      expect(@candidate.facturas).to be_an Array
      expect(@candidate.facturas.first).to be_a Date
    end

    it 'should have as many facturas as we said it should' do
      expect(@candidate.facturas.count).to eq(@candidate.count)
    end
  end

  describe '#between' do
    it 'should return false when asking for the whole year' do
      between = @candidate.between('2017-01-01', '2017-12-31')
      expect(between).to be false
    end

    it 'should return a count when asking for a small range' do
      between = @candidate.between('2017-01-01', '2017-01-03')
      expect(between).to be_an Integer
    end
  end

  describe '#self.find' do
    it 'should fail if you don\'t supply an id' do
      expect { Candidate.find }.to raise_error(ArgumentError)
    end

    it 'should fail if you supply an incorrect id' do
      expect { Candidate.find('123') }.to raise_error(ArgumentError)
    end

    it 'should return a Candidate if we give it a correct id' do
      expect(Candidate.find(@candidate.id)).to be_a Candidate
    end

    it 'should always load the same data' do
      candidate = Candidate.find(@candidate.id)

      expect(candidate.count).to eq(@count)
      expect(candidate.facturas.first).to eq(@candidate.facturas.first)
    end

    it 'should have valid data' do
      expect(@candidate.facturas.sample).to be_a Date
    end
  end

  describe '#self.all' do
    it 'should return an array with one Candidate in the beginning' do
      expect(Candidate.all.count).to eq 1
      expect(Candidate.all.first).to be_a Candidate
    end

    it 'should return more elements when we add more' do
      Candidate.new
      expect(Candidate.all.count).to eq 2
      Candidate.new
      expect(Candidate.all.count).to eq 3
    end
  end

  describe '#self.destroy_all' do
    it 'should destroy all candidates' do
      before = Candidate.all.count
      expect(before).to be > 0

      Candidate.destroy_all
      after = Candidate.all.count
      expect(after).to eq 0
    end
  end
end
