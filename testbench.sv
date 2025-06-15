module game_tb;

  wire action_A;
  wire action_B;
  logic clk;
  logic reset;
  logic [31:0] score_A;  // Updated to match 32-bit width in `scoring`
  logic [31:0] score_B;  // Updated to match 32-bit width in `scoring`

  // Instantiate scoring module
  scoring dut_score (
    .action_A(action_A),
    .action_B(action_B),
    .clk(clk),
    .reset(reset),
    .score_A(score_A),
    .score_B(score_B)
  );

  // Instantiate player_A module
  player_A dut_player_A (
    .clk(clk),
    .reset(reset),
    .action_B(action_B),
    .action_A(action_A)
  );

  // Instantiate player_B module
  player_B dut_player_B (
    .clk(clk),
    .reset(reset),
    .action_B(action_B),
    .action_A(action_A)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset sequence
  initial begin
    reset = 1;
    #10;
    reset = 0;
    #1990;  // Run simulation for 2000 time units
    $finish;  // End the simulation
  end
  
  // Dump signals for waveform analysis
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule
