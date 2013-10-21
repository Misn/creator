class String
  alias / :split
end
class String
  def rr
    if self[-1]=="\n" then return self.chop else return self end
  end
  def pp_block
    if $el_names.keys.include? self[0..9].rstrip
      #$atoms[$el_names[self[0..9].rstrip]].pp_add;
      $atoms[$el_names[self[0..9].rstrip]].coord_new($atoms[$el_names[self[0..9].rstrip]].num ,self);
      $atoms[$el_names[self[0..9].rstrip]].one_more
    end
  end
end

########COMPOUND#######
class Compound
  def initialize(filename)
    input = IO.read("#{filename}.inp")
    self.def_top(filename)
    self.def_symmetry('C1')
    self.def_consist(input)
    self.def_element_list(input)
  end
  def def_top(input)
    @top = IO.read("#{input}.top")
  end
  def top
    return @top
  end
  def def_symmetry(input)
    @symmetry = input
  end
  def symmetry
    return @symmetry
  end
  def def_consist(input)
    $a = /^ \$DATA\s+(\S+)/.match(input)
    @consist = /^ \$DATA\s+(\S+)/.match(input)[0].split[1]
  end
  def consist
    return @consist
  end
  def element_list
    return @element_list
  end
  def def_element_list(input)
    @element_dlist = /^ \$DATA\s+(\S+)/.match(input)[1].scan(/([A-Z][a-z]*)([0-9]*)/)
    #puts element_list
    @element_list = []
    @element_dlist.each {|a| @element_list.push(a[0])}
    @element_list.each{|m| m.downcase!}
  end
end
########COMPOUND_END#######

########ATOM########
class Atom
  def initialize;  @num = 0; @coord = ['hi there']; end
  def num;  return @num;  end                                     #Number
  def one_more;  @num += 1;  end                                  #Number increase
  def coord_new(n, str); @coord[n] = str; end                     #Coord array for each element
  def coord_add(n); puts @coord[n]; end                           #Coord puts
  def coord_a; return @coord; end                                 #Coord array return
  def pp_def(str);  @pp = IO.read(str);  end                      #PP-file def
  def pp_add;  puts @pp;  end                                     #PP puts
  def ecp_def(str);  @ecp = IO.read(str);  end                    #ECP-file def
  def ecp_add;  puts @ecp;  end                                   #ECP puts
  def data(str)                                                   #Reading data from files
    $atoms[str].pp_def("#{str}.pp")
    $atoms[str].ecp_def("#{str}.ecp")
  end
end
########ATOM_END########

########ATOMS########
class Atoms < Hash
  def first(compound, input)
    self.keys.each{|a| $atoms[a]=Atom.new}
    compound.element_list.each{|el| $atoms[el].data(el)}
    input.each_line{|l| l.pp_block}
  end
end
########ATOMS_END########

#######INP_FILE_CREATE#######
def inp_file_create(compound)
  puts compound.top
  puts (' $DATA')
  puts (" #{compound.consist}")
  puts compound.symmetry
  compound.element_list.each{|e| $atoms[e].coord_a.each {|c| puts c; $atoms[e].pp_add}}
  puts (" $END\n $ECP")
  compound.element_list.each {|a| $atoms[a].num.times {$atoms[a].ecp_add} }
  puts (' $END')
end

########FILES########
filename = 'exp1'
$stdout = File.open("#{filename}_r2.inp", 'w')
input = IO.read("#{filename}.inp")
compound = Compound.new(filename)

########ELEMENT_NAMES########
el_txt = IO.read('names')
key = el_txt.upcase.split("\n")
val = ['la','o','h']
a_arr = [key,val]
$el_names = Hash[*a_arr.transpose.flatten]

########ATOMS########
el_txt = IO.read('elements')
key = el_txt.split("\n")
val = (1..86).to_a
a_arr = [key,val]
$atoms = Atoms[*a_arr.transpose.flatten]                          #reading elements as keys, set Atom objects as values

########ADD_INFORMATION########
$atoms.first(compound, input)

########OUT########

inp_file_create(compound)
