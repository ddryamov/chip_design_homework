//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
#(
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);

   //Task:
   //Implement a module that converts single-bit serial data to the multi-bit parallel value.
   //
   //The module should accept one-bit values with valid interface in a serial manner.
   //After accumulating 'width' bits and receiving last 'serial_valid' input,
   //the module should assert the 'parallel_valid' at the same clock cycle
   //and output 'parallel_data' value.
   //
   //Note:
   //Check the waveform diagram in the README for better understanding.

    logic [width - 1:0] shift_reg;
    logic [2:0] valid_cntr;

    assign parallel_valid = (valid_cntr == (width - 1)) && serial_valid;
    assign parallel_data = parallel_valid ? {serial_data, shift_reg[width - 1: 1]} : '0;

    always_ff @(posedge clk) begin
        if (rst) begin
            valid_cntr <= '0;
            shift_reg  <= '0;
        end 
        else if (serial_valid) begin
            shift_reg <= {serial_data, shift_reg[width - 1 : 1]};

            if (valid_cntr == (width - 1)) begin
                valid_cntr <= '0;
            end else begin
                valid_cntr <= valid_cntr + 1'b1;
            end
        end
    end

endmodule
