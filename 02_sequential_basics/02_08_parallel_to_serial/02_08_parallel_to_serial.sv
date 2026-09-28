//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module parallel_to_serial
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      parallel_valid,
    input        [width - 1:0] parallel_data,

    output                     busy,
    output logic               serial_valid,
    output logic               serial_data
);



    parameter CNTR = $clog2(width + 1);

    logic [CNTR - 1:0] cntr = '0;

    logic [width - 1:0] shift_reg;

    reg busy_reg = '0;
    reg reg_serial_data = '0;
    logic after_parallel;
    
    assign serial_valid = parallel_valid | after_parallel;
    assign busy = busy_reg;
    assign serial_data = parallel_valid  ? parallel_data[0] : shift_reg[0];

    always_ff @ (posedge clk) begin
      if (rst) begin
        cntr <= '0;
        shift_reg <= '0;
        busy_reg <= '0;
      end
      if (parallel_valid && cntr == '0) begin
        shift_reg <= parallel_data >> 1;
        cntr <= cntr + 3'd1;
        busy_reg <= '1;
        after_parallel <= '1;
      end
      if (after_parallel)  begin
        shift_reg <= shift_reg >> 1;
        cntr <= cntr + 3'd1;
      end
      if (cntr == 3'd7) begin
        cntr <= '0;
        busy_reg <= '0;
        after_parallel <= '0;
      end

    end
   
     
endmodule


