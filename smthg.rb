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



#$atoms = Hash['h',1,'o',8,'la',57]
#$atoms_count = Array.new(100,0)
#$pp = Array.new(100,'')

#$pp[$atoms['la']] = IO.read('la.pp')
