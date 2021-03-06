push!(LOAD_PATH, pwd())

using Leitor, Heuristica_AG, Extractor, PrettyTables, Solution, Writer			# leitor (ok) :> readFile
																				# Heuristica_AG (ok) :>  ILS, iteracoes_ILS
																				# Extractor (ok) :> InstanceInfo, extractFile
																				# Solution (ok) :> Solucao, swapVertices, reverseSegment, moveSegment, swapSegments, copySolution
																				# Writer ()	:> Result, writeFile
function filterInstances()
	files = readdir("Instancias")			#Vem com Instancia/Arquivo

	instances = []
	intances_select = []

	for file in files
		push!(instances, extractFile(string("Instancias/", file)))     ########## EXTRACTOR
		#println(instances[length(instances)].name)
	end

	i = 1
	cont = 0
	open("instancias.csv") do file         
		while !eof(file) # a função vai identificar um conjunto de caracteres no fim!
			line = readline(file) # Consome uma linha e "destroi" 

			while i <= length(instances) && string(line, ".tsp") != instances[i].realName # compara linha com instancias até encontrar um match
				rm(instances[i].fileName)
				#println("Deleteted: ", instances[i].name)
				#println(instances[i].realName, " Diferente de: ", string(line, ".tsp"))
				i += 1
			end

			push!(intances_select,instances[i]) # para guardar as informações dos que sobrarem

			if i <= length(instances)
				#println(instances[i].realName, " Match: ", string(line, ".tsp"))
			end
			i += 1
			cont+=1
		end

		for j = i:length(instances)		#i é o último da lista, onde parou 
			rm(instances[j].fileName)
		end

		#println("Contador: ", cont)
	end
	
	return intances_select
end

a = filterInstances()

println("Array selecionado: ", length(a))


function edge_tsp()

	a = filterInstances()

	for i = 1:length(a)
		#println(a[i].realName, " Do Tipo de EDGE: ", a[i].edgeWeightType)
	end

end


#edge_tsp()
function Simetria(matrix::Array{Float64,2})

	(linhas, colunas) = size(matrix)

	for i = 1:linhas-1
		for j = i+1:colunas
			if abs(matrix[i,j]-matrix[j,i])>0.001
				#println("Indice i e Indice J: ", i, "-", j)
				return false
			end
		end
	end
	return true
end

function runInstances()
  
	instances = filterInstances()
	ok = [8]
	resultados = []
  
	i = 0
	for instance in instances
  
	  i += 1

	  if i ∉ ok		# só pegar o conjunto do "ok"
		continue
	  end
  
	matrix::Array{Float64,2} = readFile(instance.fileName)		########### LEITOR
  
	  println(instance.name)
	  
	  #=if !Simetria(matrix)  # retornar se for assimétrico
		println(instance.name)
		#pretty_table(matrix)
	  end=#

	  for k = 1:2
		individualTime = @elapsed solution::Solucao= ILS(matrix, 50, iteracoes_ILS(matrix)) 	######## SOLUTION // ILS, iteracoes_ILS
		println("Custo: ", solution.custo, " Tempo: ", round.(individualTime, digits=3), " s")
		push!(resultados, Result(instance.name, k, solution.custo, individualTime))				###### Result vem de onde ? WRITER
		println("Solucao: ", solution.custo)
	  end
	  println("------------------------------")
	end
  
	writeFile("Resultados3.csv", resultados, ";") ######## WRITER
  
end

#runInstances()

#println(instance.name)



# function - pr 
	#=matrix = readFile("Instancias/burma14.tsp")

	pretty_table(matrix)

	optimalSolution = ILS(matrix, 5, iteracoes_ILS(matrix))

	println(optimalSolution.caminho)
	println(optimalSolution.custo)

	println(optimalSolution.dist[170,:])
	println(optimalSolution.dist[171,:])
	println(optimalSolution.dist[172,:])
	println(optimalSolution.dist[173,:])
	println(optimalSolution.dist[174,:])
	println(optimalSolution.dist[175,:])=#



