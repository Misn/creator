#atoms = [$la,$o, $h]

#filename = gets.chomp
filename = 'exp1'
$stdout = File.open("#{filename}_r.inp", 'w')
$top = IO.read("#{filename}.top")
a = IO.read("#{filename}.inp")
puts $top
puts (' $DATA')
a.each_line{|l| l.pp_block}
puts (" $END\n $ECP")
[$la,$o, $h].each {|a| a.num.times {a.ecp_add} }
puts (' $END')

if self[0..9]=='LANTHANUM '
  $atoms[$el_names[self[0..9].rstrip]].pp_add(self);
  $atoms[$el_names[self[0..9].rstrip]].coord_new(0 ,self);
  $atoms[$el_names[self[0..9].rstrip]].one_more
elsif self[0..9]=='OXYGEN    '
  $atoms['o'].pp_add(self); $atoms['o'].one_more
elsif self[0..9]=='HYDROGEN  '
  $atoms['h'].pp_add(self); $atoms['h'].one_more
  #else puts self
end



#$atoms = Hash['h',1,'o',8,'la',57]
#$atoms_count = Array.new(100,0)
#$pp = Array.new(100,'')

#$pp[$atoms['la']] = IO.read('la.pp')
