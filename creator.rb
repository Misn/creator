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


########ATOM########
class Atom
  def initialize;  @num = 0; @coord = ['hi there']; end
  def num;  return @num;  end                                     #Number
  def one_more;  @num += 1;  end                                  #Number increase
  def el(str);  @el = str;  end                                   #Element name
  def el_p;  return @el;  end                                     #Return element name
  def coord_new(n, str); @coord[n] = str; end                     #Coord array for each element
  def coord_add(n); puts @coord[n]; end                           #Coord puts
  def coord_a; return @coord; end                                 #Coord array return
  def pp_def(str);  @pp = IO.read(str);  end                      #PP-file def
  def pp_add;  puts @pp;  end                                     #PP puts
  def ecp_def(str);  @ecp = IO.read(str);  end                    #ECP-file def
  def ecp_add;  puts @ecp;  end                                   #ECP puts
  def data(str)
    $atoms[str].pp_def("#{str}.pp")
    $atoms[str].ecp_def("#{str}.ecp")
  end
end
########ATOM_END########

########ATOMS########
class Atoms < Hash
  def first
    self.keys.each{|a| $atoms[a]=Atom.new}
    self.keys.each{|a| $atoms[a].el(a)}
  end
end
########ATOMS_END########

######## TOP ########
def top_def(str)
  return Proc.new{$top = IO.open("#{str}.top")}
end

########FILES########
filename = 'exp1'
$stdout = File.open("#{filename}_r2.inp", 'w')
$top = IO.read("#{filename}.top")
a = IO.read("#{filename}.inp")

########EL_NAMES########
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
$atoms.first

########ADD########
comp = /^ \$DATA\s+(\S+)/.match(a)[0].split[1]
el_dlist = /^ \$DATA\s+(\S+)/.match(a)[1].scan(/([A-Z][a-z]*)([0-9]*)/)
#puts el_list
el_list = []
el_dlist.each {|a| el_list.push(a[0])}
el_list.each{|m| m.downcase!}
el_list.each{|el| $atoms[el].data(el)}
a.each_line{|l| l.pp_block}

########OUT########
puts $top
puts (' $DATA')
puts (" #{comp}")
puts ('C1')
el_list.each{|e| $atoms[e].coord_a.each {|c| puts c; $atoms[e].pp_add}}
puts (" $END\n $ECP")
el_list.each {|a| $atoms[a].num.times {$atoms[a].ecp_add} }
puts (' $END')

