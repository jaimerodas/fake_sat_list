# frozen_string_literal: true

require 'sinatra'

# This is where the candidates are going to connect to the system. It should
# return either the number of invoices in the selected period, 'false' in case
# the period has more than 100 invoices, or 'error' if the parameters are wrong.
get '/facturas' do
end

# This we will use to keep track of the candidate id's we give out, and what
# their answers should be.
get '/candidatos' do
end

# This is where we will create a candidate, it should return a UID corresponding
# to that candidate, and the number of invoices created. They will always
# belong to the current year.
post '/candidatos' do
end

# This is how we will delete candidates. No user/password needed for now.
# It's pretty inconnsequential anyway.
delete '/candidato/:id' do
end
