defmodule Graph do
defstruct type: :directed, vertices: %{}, edges: %{}, outedges: %{}

@type vertex :: term
@type graph_type :: :directed | :undirected
@type t :: %__MODULE__{type: graph_type, 
                        vertices: %{},
                        edges: %{},
                        outedges: %{}
                       }

def new (type) do
  %__MODULE__ {type: type}
end

def add_vertex(vertex, %__MODULE__{vertices: vs} = g) do
   case Map.get(vs, vertex) do
      nil -> %__MODULE__{g | vertices: Map.put(vs,vertex,vertex)}
      _   -> g
end
end

def add_outedge(%__MODULE__{outedges: os} = g,vertex1,vertex2) do

out_neighbors =  case Map.get(os,vertex1) do
   nil -> MapSet.new([vertex2])
   ms ->  MapSet.put(ms,vertex2)
end

  %__MODULE__{g | outedges: Map.put(os,vertex1,out_neighbors)}
   
end


def add_edge(edge, weight, %__MODULE__{edges: es} = g) do
   {v1,v2} = edge
   g = add_outedge(g,v1,v2)
   case Map.get(es, edge) do
      nil ->  %__MODULE__{g | edges: Map.put(es,edge,weight)}
      _   -> %__MODULE__ {g | edges: Map.put(es,edge,weight)}
end
end

def add_vertices(g, vertices) do
   g = Enum.reduce(vertices,g,&add_vertex/2)
end

def do_dfs(%Graph{vertices: vs,outedges: oe} = g,[],visited)
do
end

def edge_weight_sort(%Graph{vertices: vs,outedges: oe, edges: es} = g,start,dest) do
    case Map.get(es,{start,dest}) do
      nil -> 999999
      ms  -> ms
   end
end

def do_dfs(%Graph{vertices: vs,outedges: oe} = g,[start|rest],visited) do
  if MapSet.member?(visited,start) do
     do_dfs(g,rest,visited)
  else
    IO.puts("The visited node is #{inspect(start)}")
    visited = MapSet.put(visited,start)
    out =
            oe
            |> Map.get(start, MapSet.new())
            |> MapSet.to_list()
            |> Enum.sort_by(fn id  -> Graph.edge_weight_sort(g,start,id) end)
     do_dfs(g,out ++ rest,visited)
  end
end
 

def dfs(g,start_vertex) do
   do_dfs(g,[start_vertex],MapSet.new())
end
end



g = Graph.new(:undirected)
g = Graph.add_vertices(g,[1,2,3,4])
g = Graph.add_edge({1,2},5,g)
g = Graph.add_edge({1,2},88,g)
g = Graph.add_edge({1,3},4,g)
g = Graph.add_edge({1,4},1,g)
Graph.dfs(g,1)
IO.puts ("the new struct is #{inspect(g)}")
