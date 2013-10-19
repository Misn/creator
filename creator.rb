class String
  alias / :split
end
class String
  def rr
    if self[-1]=="\n" then return self.chop else return self end
  end
  def pp_block
    if self[0..9]=='LANTHANUM '
      $atoms['la'].pp_add(self); $atoms['la'].one_more
    elsif self[0..9]=='OXYGEN    '
      $atoms['o'].pp_add(self); $atoms['o'].one_more
    elsif self[0..9]=='HYDROGEN  '
      $atoms['h'].pp_add(self); $atoms['h'].one_more
      #else puts self
    end
  end
end


########ATOM########
class Atom
  def initialize;  @num = 0;  end
  def num;  return @num;  end                                     #Number
  def one_more;  @num += 1;  end                                  #Number increase
  def el(str);  @el = str;  end                                   #Element name
  def el_p;  return @el;  end                                     #Return element name
  def coord(str) @coord = str; end                                #TODO make coord array for each element
  def pp_def(str);  @pp = IO.read(str);  end                      #PP-file def
  def pp_add(str);  puts str.rr+@pp;  end                         #PP puts
  def ecp_def(str);  @ecp = IO.read(str);  end                    #ECP-file def
  def ecp_ndef(str);  @ecp = " #{str.upcase} none";  end          #Empty ECP def
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
$stdout = File.open("#{filename}_r.inp", 'w')
$top = IO.read("#{filename}.top")
a = IO.read("#{filename}.inp")

########ATOMS########
el_txt = IO.read('elements')
key = el_txt.split("\n")
val = (1..86).to_a
a_arr = [key,val]
$atoms = Atoms[*a_arr.transpose.flatten]                          #reading elements as keys, set Atom objects as values
$atoms.first

########ADD########
el_list = /^ \$DATA\s+(\S+)/.match(a)[1].scan(/([A-Z][a-z]*)([0-9]*)/)
#puts el_list
el_list.each{|m| m[0].downcase!}
el_list.each{|el| $atoms[el[0]].data(el[0])}

########OUT########
puts $top
puts (' $DATA')
a.each_line{|l| l.pp_block}
puts (" $END\n $ECP")
el_list.each {|a| $atoms[a[0]].num.times {$atoms[a[0]].ecp_add} }
puts (' $END')
