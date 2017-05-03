# frozen_string_literal: true

require 'securerandom'
require 'date'
require 'time'

# This class generates, lists and deletes candidates
class Candidate
  BASE_PATH = 'candidates/'

  # With an optional number of elements, this creates a Candidate
  def initialize(id = false)
    id ? find_file(id) : create_file
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

  # This method returns the array of Times
  def facturas
    @facturas ||= Array.new(count) { create_invoice }
  end

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
    Dir["#{BASE_PATH}*"].map { |id| find(id.sub(BASE_PATH, '')) }
  end

  # This method destroys all candidates
  def self.destroy_all
    all.each(&:destroy)
  end

  private

  # This method returns the path where the Candidate file is stored
  def path
    @path ||= "#{BASE_PATH}#{id}"
  end

  # This method creates the Candidate file
  def create_file
    File.open(path, 'w') do |file|
      facturas.each { |factura| file.puts(factura.to_time) }
    end
  end

  # This method returns a random Time in 2017
  def create_invoice
    rand(Date.new(2017, 1, 1)..Date.new(2017, 12, 31))
  end

  # This method finds and reads a file and turns it into a candidate
  def find_file(id)
    @id = id
    @facturas = File.open(path, 'r').read.split("\n").map { |t| Date.parse(t) }
    @count = @facturas.count
  end
end
