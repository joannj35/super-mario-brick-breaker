
module score_calculator (
					input		logic clk,
					input		logic resetN,
					input		logic [3:0] bricks,
					
					output logic [4:0] ones,
					output logic [4:0] tens,
					output logic [4:0] hundreds,
					output logic [4:0] thousands
);


int counter = 0; // It is used to choose a random score for [?] boxes

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		ones = 0;
		tens = 0;
		hundreds = 0;
		thousands = 0;
	end else begin
		if(counter==9)
			counter = 1;
		counter = counter+1;
		if(bricks==1 ) begin
			ones = ones + 5;
		end 
		else if(bricks == 2) begin
			tens = tens + counter;
		end 
		else if(bricks == 3) begin
			tens = tens + 2;
		end
		
		tens = tens + (ones >= 10);
		hundreds = hundreds + (tens >= 10);
		thousands = thousands + (hundreds >= 10);
		
		ones = (ones >= 10) ? (ones - 10) : ones;
		tens = (tens >= 10) ? (tens - 10) : tens;
		hundreds = (hundreds >= 10) ? (hundreds - 10) : hundreds;
		thousands = (thousands >= 10) ? (thousands - 10) : thousands;
	end
end

endmodule
