# frozen_string_literal: true

require 'securerandom'
require 'date'
require 'fileutils'

# This class generates, lists and deletes candidates
class Candidate
  BASE_PATH = 'candidates/'

  # This method creates the candidate object. Either from a file or from scratch
  def initialize(*id)
    id.empty? ? create_file : initialize_from_file(id.first)
  end

  # This method deletes a candidate
  def destroy
    File.delete(path)
  end

  # This method returns the number of invoices in this instance
  def count
    @count ||= rand(1000..2000)
  end

  # This method returns or sets the id for the Candidate
  def id
    @id ||= SecureRandom.uuid
  end

  # This method returns the number of facturas between two dates, as long as
  # the number is less than or equal to 100. Otherwise, it returns false
  def between(start, finish)
    range = Date.parse(start)..Date.parse(finish)
    result = facturas.select { |date| range.cover? date }.count
    result > 100 ? false : result
  end

  # This method finds and returns a candidate
  def self.find(id)
    new(id)
  rescue Errno::ENOENT
    raise ArgumentError, 'No such candidate'
  end

  # This method returns all candidates
  def self.all
    Dir["#{BASE_PATH}*"].map { |id| id.sub(BASE_PATH, '') }
  end

  # This method destroys all candidates
  def self.destroy_all
    all.each do |id|
      Candidate.find(id).destroy
    end
  end

  # This method returns the array of Times
  def facturas
    @facturas ||= Array.new(count) { create_invoice }
  end

  private

  # This method returns the path where the Candidate file is stored
  def path
    @path ||= "#{BASE_PATH}#{id}"
  end

  # This method makes sure the directory exists and creates the file
  def create_file
    check_if_directory_exists
    File.open(path, 'w') { |file| add_facturas_to(file) }
  end

  # This method adds the dates from facturas to a file
  def add_facturas_to(file)
    facturas.each { |factura| file.puts(factura.to_time) }
  end

  # This method reads the dates from a previously generated file
  def read_facturas_from_file
    File.open(path, 'r').read.split("\n").map do |row|
      Date.parse(row)
    end
  end

  # This method returns a random Time in 2017
  def create_invoice
    rand(Date.new(2017, 1, 1)..Date.new(2017, 12, 31))
  end

  # This method checks if the path folder exists. If it doesn't, it creates it
  def check_if_directory_exists
    dirname = File.dirname(path)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
  end

  # This method finds and reads a file and turns it into a candidate
  def initialize_from_file(id)
    @id = id
    @facturas = read_facturas_from_file
    @count = @facturas.count
  end
end
