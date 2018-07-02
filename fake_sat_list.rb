# frozen_string_literal: true

require 'sinatra'
require 'json'
require './models/candidate'

# This is where the candidates are going to connect to the system. It should
# return either the number of invoices in the selected period, 'false' in case
# the period has more than 100 invoices, or 'error' if the parameters are wrong.
get '/facturas' do
  content_type :json

  unless params['id'] && params['start'] && params['finish']
    status 400
    return 'Te faltan parámetros'.to_json
  end

  begin
    result = Candidate.find(params['id']).between(
      params['start'],
      params['finish']
    )
  rescue ArgumentError
    status 400
    result = 'Argumentos inválidos'
  end
  return (result || 'Hay más de 100 resultados').to_json
end

# This is the main page, we will use it to give a brief description of the
# problem and how it should be approached.
get '/' do
  erb :index
end

# This we will use to keep track of the candidate id's we give out, and what
# their answers should be.
get '/candidatos' do
  candidatos = Candidate.all
  erb :candidatos, locals: { candidatos: candidatos }
end

# This is where we will create a candidate, it should return a UID corresponding
# to that candidate, and the number of invoices created. They will always
# belong to the current year.
post '/candidatos' do
  Candidate.new
  redirect to '/candidatos'
end

get '/candidato/:id' do
  Candidate.find(params[:id]).count.to_json
end

# This is how we will delete candidates. No user/password needed for now.
# It's pretty inconsequential anyway.
get '/candidato/:id/borrar' do
  Candidate.find(params[:id]).destroy
  redirect to '/candidatos'
end
