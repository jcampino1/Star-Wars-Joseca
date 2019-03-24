require 'httparty'

class ConsultasController < ApplicationController

	#url_base = 'https://swapi.co/api/people/1'

	def index
		@response = HTTParty.get('https://swapi.co/api/' + 'films')
		@response = @response["results"]
	end

	def consulta_especifica
		# Es una pelicula
		categoria = params[:categoria]
		indice = params[:indice]
		direccion = params[:direccion]

		if direccion
			ruta = direccion
		else
			ruta = 'https://swapi.co/api/' + categoria + '/' + indice
		end

		@response = HTTParty.get(ruta)

		@response.each do |key, value|
			if key == 'vehicles' or key == 'species'
				@response.delete(key)

			else
				if value.class == Array
					nombres = []
					for elem in value
						r = HTTParty.get(elem)
						if key == "films"
							nombres.push([r["title"], elem])
						else
							nombres.push([r["name"], elem])
						end
					end
					@response[key] = nombres
				end

				if key == 'homeworld'
					r = HTTParty.get(value)
					@response[key] = [[r["name"], value]]
				end
			end
		end
	end

	def persona
		@direccion = params[:direccion]
		@response = HTTParty.get(@direccion)

		@response.each do |key, value|
			if key == 'vehicles' or key == 'species'
				@response.delete(key)

			else
				if value.class == Array
					nombres = []
					for elem in value
						r = HTTParty.get(elem)
						if key == "films"
							nombres.push([r["title"], elem])
						else
							nombres.push([r["name"], elem])
						end
					end
					@response[key] = nombres
				end
			end
		end

	end

end
