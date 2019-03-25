require 'httparty'
require 'json'

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

	def search
		texto = params[:texto]
		busquedas = ['people', 'starships', 'planets', 'films']
		contador = 0

		@resultados = {}

		busquedas.each do |area|
			sirven = []

			personas = HTTParty.get('https://swapi.co/api/' + area)
			siguiente = true
			while siguiente
				personas["results"].each do |persona|
					if area == 'films'
						if persona["title"].include?(texto)
							sirven.push([persona["title"], persona["url"]])
						end
					else
						if persona["name"].include?(texto)
							sirven.push([persona["name"], persona["url"]])
						end
					end
				end
				siguiente = personas["next"]
				if siguiente
					personas = HTTParty.get(siguiente)
				end
			end
			@resultados[contador] = sirven
			contador += 1
		end
	end

end
