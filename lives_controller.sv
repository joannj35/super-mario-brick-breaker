
module lives_controller (
					input	logic clk,
					input	logic resetN,
					input	logic startOfFrame,
					input   logic toggleX,
					output  logic [3:0] lives,
					output logic [7:0] RGBout
					
);

int INL = 3;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
	lives<=INL;
	end
	else begin
		// initial values
		//if(startOfFrame) begin
			if(toggleX) begin
				INL = INL - 1'b1;
			end
			lives<=INL;
			RGBout <= 8'hff;
		end
	//end
end

endmodule
