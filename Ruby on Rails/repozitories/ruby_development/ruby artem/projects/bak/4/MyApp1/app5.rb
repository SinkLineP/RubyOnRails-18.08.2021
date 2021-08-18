#encoding: cp866

print "Š ªãî áã¬¬ã ¡ã¤¥¬ ®âª« ¤ë¢ âì §  ¬¥áïæ: "
x = gets.to_f

print "‘ª®«ìª® ¬¥áïæ¥¢: "
n = gets.to_i

s = 0

1.upto(n) do |mm|
	s = s + x
	puts " ª®¯«¥­¨ï §  #{mm} ¬¥áïæ: #{s}"
end
sleep = 0.5
