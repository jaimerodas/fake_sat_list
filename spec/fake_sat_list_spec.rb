# frozen_string_literal: true

require './fake_sat_list.rb'
require 'rack/test'
require 'spec_helper'

ENV['RACK_ENV'] = 'test'

RSpec.describe 'fake_sat_list' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe '/facturas' do
    before(:all) do
      @candidate = Candidate.new
    end

    after(:all) do
      Candidate.destroy_all
    end

    it 'should return error when no arguments are passed' do
      get '/facturas'
      expect(last_response.status).to eq 400
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq 'Te faltan parámetros'.to_json
    end

    it 'should return an error when the candidate is invalid' do
      get '/facturas', id: 'abcd', start: '2017-01-01', finish: '2017-01-05'
      expect(last_response.status).to eq 400
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq 'Argumentos inválidos'.to_json
    end

    it 'should return a number if the parameters are valid' do
      get '/facturas',
          id: @candidate.id,
          start: '2017-01-01',
          finish: '2017-01-05'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(JSON.parse(last_response.body)).to be >= 0
    end

    it 'should return a string if the range is too big' do
      get '/facturas',
          id: @candidate.id,
          start: '2017-01-01',
          finish: '2017-12-31'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq 'Hay más de 100 resultados'.to_json
    end
  end

  describe '/' do
    it 'should return a small website' do
      get '/'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'text/html;charset=utf-8'
      expect(last_response.body).to include('Ejercicio para Candidatos')
    end
  end

  describe '/candidatos' do
    before(:all) do
      10.times { Candidate.new }
    end

    after(:all) do
      Candidate.destroy_all
    end

    it 'should list candidates' do
      get '/candidatos'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'text/html;charset=utf-8'
      expect(last_response.body.scan(/Borrar/).length).to be 10
    end

    it 'should have a link to create a new candidate' do
      get '/candidatos'

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'text/html;charset=utf-8'
      expect(last_response.body).to include('Crear Candidato')
    end
  end

  describe '/candidatos/:id/borrar' do
    before(:all) do
      @candidate = Candidate.new
    end

    after(:all) do
      Candidate.destroy_all
    end

    it 'should erase candidates' do
      get '/candidatos'
      expect(last_response.body.scan(/Borrar/).length).to be 1

      get "/candidatos/#{@candidate.id}/borrar"
      expect(last_response.body.scan(/Borrar/).length).to be 0
    end
  end
end
