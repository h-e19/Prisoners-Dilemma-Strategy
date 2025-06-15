module player_A(
  input clk,
  input reset,
  input action_B,
  output reg action_A
);
   reg[1:0] next_state;
   reg[1:0] current_state;

   reg [31:0] round_count;
   reg [31:0] b_cooperate_count;
   
   reg [31:0] b_cooperate_rate;
  reg [31:0] forgiveness_threshold;
   
   real pi = 3.141592653589793;
   
   localparam cooperate = 2'b00;
   localparam defect = 2'b01;

   always @(negedge clk or posedge reset) begin
      if (reset) begin
          round_count <= 0;
          b_cooperate_count <= 0;
          current_state <= cooperate;
      end else begin
        
        if (action_B==0) begin 
            b_cooperate_count = b_cooperate_count + 1;
        end
        
          current_state <= next_state;
        
          if (round_count > 0) begin
            b_cooperate_rate <= (b_cooperate_count*100 / round_count);
          end
          
        forgiveness_threshold <= 100*(1 - 0.3 * $sin(pi * round_count / 200));
      end
   end
  
  always @(posedge clk) begin
    
          round_count <= round_count + 1; 
  end
   
   always @(*) begin
      case(action_B)
         0: begin  
           
           if (round_count > 198) begin
               next_state = defect;
            end else begin
               next_state = cooperate;
            end
         end
         1: begin
            if (b_cooperate_rate >= forgiveness_threshold) begin
               next_state = cooperate;
            end 
           else if (round_count > 199) begin
             next_state = defect;
           end
           else begin
               next_state = defect;
            end
         end
         default: next_state = cooperate;
      endcase;

     
      if (current_state == cooperate) begin
         action_A = 0;  // Cooperate
      end else begin
         action_A = 1;  // Defect
      end
   end
endmodule
