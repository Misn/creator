#a = File.new(gets.chomp)
#a.path = gets.chomp
#a = Hash["a", 100, "b", 200]
#$atoms_count = Array.new(100,0)
#b = 0
#b += 1
#puts b

#key = (1..10).to_a
#val = ('a'..'j').to_a
#a_arr = [key,val]
#a_hash = Hash[*a_arr.transpose.flatten]
#$atoms = (1..10).to_a
#a_hash.each{|a| puts a}

class Exp
@val = 0
  def set_val(p)
    @val = p
  end
  def puts_val
    puts @val
  end
end

key = (1..10).to_a
val = ('a'..'j').to_a
a_arr = [key,val]
a_hash = Hash[*a_arr.transpose.flatten]
a_hash.keys.each{|a| a_hash[a]=Exp.new}
a_hash.values.each{|a| a.set_val(777)}
a_hash.values.each{|a| a.puts_val}

#c = [1,3,3]
#a = 2
#puts a
#c.each{|el| el = Exp.new}
#c.map{|el| puts el}
#a.set_val(5)
#a.puts_val