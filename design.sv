`include "PlayerHA.sv"
`include "PlayerHB.sv"

module scoring(
    input clk,
    input reset,
    input action_A, // Action of Player A (0: cooperate, 1: defect)
    input action_B, // Action of Player B (0: cooperate, 1: defect)
    output reg [31:0] score_A, // Score of Player A
    output reg [31:0] score_B  // Score of Player B
);
  
    reg [31:0] cooperate_a_count, cooperate_b_count, defect_a_count, defect_b_count;
  
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            score_A <= 0;
            score_B <= 0;
            cooperate_a_count <= 0;
            cooperate_b_count <= 0;
            defect_a_count <= 0;
            defect_b_count <= 0;
        end else begin
            case({action_A, action_B})
                2'b00: begin // Both cooperate
                    score_A <= score_A + 5;
                    score_B <= score_B + 5;
                    cooperate_a_count <= cooperate_a_count + 1;
                    cooperate_b_count <= cooperate_b_count + 1;
                end
                2'b01: begin // A cooperates, B defects
                    score_A <= score_A + 1;
                    score_B <= score_B + 4;
                    cooperate_a_count <= cooperate_a_count + 1;
                    defect_b_count <= defect_b_count + 1;
                end
                2'b10: begin // A defects, B cooperates
                    score_A <= score_A + 4;
                    score_B <= score_B + 1;
                    cooperate_b_count <= cooperate_b_count + 1;
                    defect_a_count <= defect_a_count + 1;
                end
                2'b11: begin // Both defect
                    score_A <= score_A + 2;
                    score_B <= score_B + 2;
                    defect_a_count <= defect_a_count + 1;
                    defect_b_count <= defect_b_count + 1;
                end
            endcase
        end
    end
endmodule
