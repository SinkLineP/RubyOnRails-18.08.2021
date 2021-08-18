@table = ['-','-','-','-','-','-','-','-','-']

def cells_show
	puts "Number of cells:"
	puts "-1-|-2-|-3-"
	puts "-4-|-5-|-6-"
	puts "-7-|-8-|-9-"
	puts "Current situation:"
	puts "-#{@table[0]}-|-#{@table[1]}-|-#{@table[2]}-"
	puts "-#{@table[3]}-|-#{@table[4]}-|-#{@table[5]}-"
	puts "-#{@table[6]}-|-#{@table[7]}-|-#{@table[8]}-"
end

def move(num)
	if num == 1
		puts "#{@player1} enter a number cell to make move:"
	else
		puts "#{@player2} enter a number cell to make move:"
	end

	number_cell = gets.to_i

	while number_cell<1 || number_cell>9 || @table[number_cell-1]=="X" || @table[number_cell-1]=="0" do
		puts "Input correct a cell number"
		number_cell = gets.to_i
	end

	if num == 1
		@table[number_cell-1]='X'
	else
		@table[number_cell-1]='0'
	end


end

def check
	3.times do |i|
		if @table[i*3] == @table[i*3+1] && @table[i*3+1] == @table[i*3+2]
			return @table[i]
		elsif @table[i] == @table[i+3] && @table[i+3] == @table[i+6]
			return @table[i]
		elsif (@table[2] == @table[4] && @table[4] == table[6]) || (@table[0] == @table[4] && @table[4] == table[8])
			return @table[i]
		end
	end		
	return '-'
end

def how_rezult
	if @win == 'X'
		puts "#{@player1} win!"
	elsif @win == '0'
		puts "#{@player2} win!"
	else
		puts "OLOLOLo!!!"
	end
end

puts "Input player name 1:"
@player1 = gets.chomp
puts "Input player name 2:"
@player2 = gets.chomp
cells_show
9.times do |i|
	if i%2 != 1
		move(1)
	else
		move(2)
	end

	cells_show
	
	if i>4
		@win=check
		if @win != '-'
			break
		end
	end	
end
how_rezult