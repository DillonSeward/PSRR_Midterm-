using PRAS
using TimeZones


empty_str = String[] #declaring empty strings, floats, and ints for use in the empty generatorstorages and emptystorages struct
empty_int(x) = Matrix{Int}(undef, 0, x)
empty_float(x) = Matrix{Float64}(undef, 0, x)
pacific_tz = TimeZone("America/Los_Angeles") #delaring time zone for use in simulation time stamps

load_vector = [1775.835, 1669.815, 1590.3, 1563.795, 1563.795, 1590.3, 1961.37, 2279.43, 2517.975, 2544.48, 2544.48, 
  2517.975, 2517.975, 2517.975, 2464.965, 2464.965, 2623.995, 2650.5, 2650.5, 2544.48, 2411.955, 2199.915, 1934.865, 1669.815]  #load data over 24 hours so i can multiply with node load usage percent

load_float = [.038*load_vector; .034*load_vector; .063*load_vector; .026*load_vector; .025*load_vector; .048*load_vector; 
  .044*load_vector; .060*load_vector; .061*load_vector; .068*load_vector; 0*load_vector; 0*load_vector;
  .093*load_vector; .068*load_vector; .111*load_vector; .035*load_vector; 0*load_vector; .117*load_vector; 
  .064*load_vector; .045*load_vector; 0*load_vector; 0*load_vector; 0*load_vector; 0*load_vector]  #multiplying the percatnge each node expereinces fom the load data over 24 hours

load_matrix = reshape(load_float, length(load_float) ÷ length(load_vector), length(load_vector)) #preparing data to be compatible with struct
load_int_matrix = Int.(ceil.(load_matrix))

node_list = ["Node 1", "Node 2", "Node 3", "Node 4", "Node 5", "Node 6", #name of all the nodes 
  "Node 7", "Node 8", "Node 9", "Node 10", "Node 11", "Node 12", 
  "Node 13", "Node 14", "Node 15", "Node 16", "Node 17", "Node 18", 
  "Node 19", "Node 20", "Node 21", "Node 22", "Node 23", "Node 24"]

#declariing the regions struct filled with node/region names and load data at each node/region over 24 hours
regions = Regions{24, MW}(
  node_list,
  load_int_matrix)

#lambda and mu for generators
Lambda_gen = 0.047368 #obtained lambda from FOR = Lambda/(Lambda + Mu) where mu and FOR are given
Mu_gen = 0.9
#=
declaring the generator struct with its names, categories, and unreliability and repair rate
to work with PRAS i had to make fake 0 capacity perfectly reliable generators and they are noted by the "F" tag in their name
along with 0 capacity, 0 unreliability, and 1 repair rate 
=#
generators = Generators{24,1,Hour,MW}(
  ["G1", "G2", "GF3", "GF4", "GF5", "GF6", "G7", "GF8", "GF9", "GF10", "GF11", "GF12",
  "G13", "GF14", "G15A", "G15B", "G16", "GF17", "G18", "GF19", "GF20", "G21", "G22", "G23A", "G23B", "GF24"], #Names of Generators 
  ["Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", 
  "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens", "Gens"], #Category of Generators 
  [fill(152, 1, 24); fill(152, 1, 24); fill(0, 1, 24);  fill(0, 1, 24);  fill(0, 1, 24);  fill(0, 1, 24);   
  fill(350, 1, 24); fill(0, 1, 24); fill(0, 1, 24); fill(0, 1, 24); fill(0, 1, 24); fill(0, 1, 24); fill(591, 1, 24);               
  fill(0, 1, 24); fill(60, 1, 24);  fill(155, 1, 24); fill(155, 1, 24); fill(0, 1, 24); fill(400, 1, 24); fill(0, 1, 24);   #capacitry of generators
  fill(0, 1, 24); fill(400, 1, 24); fill(300, 1, 24); fill(310, 1, 24); fill(350, 1, 24); fill(0, 1, 24)],
  [fill(Lambda_gen, 1, 24); fill(Lambda_gen, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); #unreliability of each generator
  fill(Lambda_gen, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); 
  fill(Lambda_gen, 1, 24); fill(0.0, 1, 24); fill(Lambda_gen, 1, 24); fill(Lambda_gen, 1, 24); fill(Lambda_gen, 1, 24); fill(0.0, 1, 24);  
  fill(Lambda_gen, 1, 24); fill(0.0, 1, 24); fill(0.0, 1, 24); fill(Lambda_gen, 1, 24); fill(Lambda_gen, 1, 24); fill(Lambda_gen, 1, 24); fill(Lambda_gen, 1, 24); fill(0.0, 1, 24)],
  [fill(Mu_gen, 1, 24); fill(Mu_gen, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); 
  fill(Mu_gen, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); 
  fill(Mu_gen, 1, 24); fill(1.0, 1, 24); fill(Mu_gen, 1, 24); fill(Mu_gen, 1, 24); fill(Mu_gen, 1, 24); fill(1.0, 1, 24);  #repair rate of each generator 
  fill(Mu_gen, 1, 24); fill(1.0, 1, 24); fill(1.0, 1, 24); fill(Mu_gen, 1, 24); fill(Mu_gen, 1, 24); fill(Mu_gen, 1, 24); fill(Mu_gen, 1, 24); fill(1.0, 1, 24)])      

emptystors = Storages{24,1,Hour,MW,MWh}(  #empty sorages, since there are none in the system
  (String[] for _ in 1:2)...,
  (empty_int(24) for _ in 1:3)...,        
  (empty_float(24) for _ in 1:5)...)

emptygenstors = GeneratorStorages{24,1,Hour,MW,MWh}( #empty generator sorages, since there are none in the system
  (empty_str for _ in 1:2)...,            
  (empty_int(24) for _ in 1:3)..., (empty_float(24) for _ in 1:3)..., (empty_int(24) for _ in 1:3)...,
  (empty_float(24) for _ in 1:2)...)

capacity_vector = [175, 175, 350, 175, 175, 175, 400, 175, 350, 175,  #preping capcity data to be compatible with struct
  350, 175, 175, 400, 400, 400, 400, 500, 500, 
  500, 500, 500, 500, 500, 1000, 500, 500, 500, 
  500, 500, 1000, 1000, 1000, 500]
capacity_matrix = fill(capacity_vector, 24, 1)
capacity_matrix = hcat(capacity_matrix...) 

interfaces = Interfaces{24,MW}( #declaring interface struct with region from to region to data and capactities
  [1, 1, 1, 2, 2, 3, 
  3, 4, 5, 6, 7, 8,            #line connects from region name
  8, 9, 9, 10, 10, 11, 
  11, 12, 12, 13, 14, 15, 
  15, 15, 16, 16, 17, 17,
  18, 19, 20, 21],
  [2, 3, 5, 4, 6, 9, 
  24, 9, 10, 10, 8, 9,         #line connects to region name
  10, 11, 12, 11, 12, 13, 
  14, 13, 23, 23, 16, 16, 
  21, 24, 17, 19, 18, 22,
  21, 20, 23, 22],
  capacity_matrix,  #forward capacity of lines
  capacity_matrix)  #backward capacity of lines 

#lambda and mu of lines 
Lambda_line = 0.018947  #obtained lambda from FOR = Lambda/(Lambda + Mu) where mu and FOR are given
Mu_line = 0.9
lines = Lines{24,1,Hour,MW}( #declaring the line struct with names, categories, capactities, unreliability, and repair rates of the lines
  ["L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8", "L9", "L10", "L11", "L12", "L13", "L14", "L15", "L16", "L17", 
  "L18", "L19", "L20", "L21", "L22", "L23", "L24", "L25", "L26", "L27", "L28", "L29", "L30", "L31", "L32", "L33", "L34"],         #names of lines 
  ["Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", 
  "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", "Lines", #category of lines
  "Lines", "Lines", "Lines", "Lines"],
  capacity_matrix,  #forward capacity of lines
  capacity_matrix,  #backward capacity of lines 
  fill(Lambda_line, 34, 24),    #unreliability of each line                                                                     
  fill(Mu_line, 34, 24))   #Repair rate of each line

#=
System model is delcared with regions, interfaces, and generator structs
generator locations are specfied where the index of the vector indicates what node the generator is at
and the number corresponds to the generator in that region acording to the index of the generator names 
in the generator struct.
This same logic is followed for lines declaration in accordance to the index in the interfaces struct
=#
sys = SystemModel(
  regions, interfaces, 
  generators,  [1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9, 10:10, 11:11, 12:12, #declaring what region each generator is at
  13:13, 14:14, 15:16, 17:17, 18:18, 19:19, 20:20, 21:21, 22:22, 23:23, 24:25, 26:26], 
  emptystors, fill(1:0, 24),
  emptygenstors, fill(1:0, 24), lines, [1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8,   #delcaring what lines are at what interfaces
  9:9, 10:10, 11:11, 12:12, 13:13, 14:14, 15:15, 16:16, 17:17, 18:18, 19:19, 20:20, 21:21, 
  22:22, 23:23, 24:24, 25:25, 26:26, 27:27, 28:28, 29:29, 30:30, 31:31, 32:32, 33:33, 34:34], 
  ZonedDateTime(2024,10,30,1,pacific_tz):Hour(1):ZonedDateTime(2024,10,30,24,pacific_tz))   #delcaring that the simulation runs for 24 hours with 1 hour steps

shortfall, = assess(sys, SequentialMonteCarlo(samples = 10000), Shortfall()) #assesing the system that was delcared just above

println()
println("---------Overall LOLE and 24 Hour EUE of System---------") #printing overall LOLE and 24 hour EUE of system
eue_overall = EUE(shortfall)
lole_overall = LOLE(shortfall)
println("Overall ",eue_overall)
println("Overall ", lole_overall)
println()

println("--------------EUE per Hour--------------") #printing EUE hour per hour
for i in 1:24
  hour = ZonedDateTime(2024, 10, 30, i, pacific_tz)
  eue_hour = EUE(shortfall, hour)
  println("Hour $i ", eue_hour)
end
println()

println("---------------LOLE per Node--------------") #printing LOLE node by node
for i in 1:24
  node = node_list[i]
  lole_node = LOLE(shortfall, node)
  println("Node $i ", lole_node)
end
println()

#=
println("--------------Non-Zero EUE per Hour--------------") #printing EUE hour per hour
for i in 1:24
  hour = ZonedDateTime(2024, 10, 30, i, pacific_tz)
  eue_hour = EUE(shortfall, hour)
  if val(eue_hour.eue) != 0.0
    println("Hour $i ", eue_hour)
  end
end
println()

println("---------------Non-Zero LOLE per Node--------------") #printing LOLE node by node
for i in 1:24
  node = node_list[i]
  lole_node = LOLE(shortfall, node)
  if val(lole_node.lole) != 0.0
    println("Node $i ", lole_node)
  end
end
println()

println("---------------Non-Zero EUE per Hour per Node--------------") #printing non-zero EUE for every node Per hour for improvement assesment
for i in 1:24
  for j in 1:24
    node = node_list[j]
    hour = ZonedDateTime(2024, 10, 30, i, pacific_tz)
    eue_node_hour = EUE(shortfall, node, hour)
    if val(eue_node_hour.eue) != 0.0
      println("Hour $i Node $j ", eue_node_hour)
    end
  end
end
=#

