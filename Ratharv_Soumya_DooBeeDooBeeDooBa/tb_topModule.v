`timescale 1ns/1ps

module tb_topModule;

    // DUT signals
    reg clk;
    reg receiveData;    // serial input to DUT
    wire transmitData;
    reg reset;  // serial output from DUT
    wire reset1;
    wire [7:0] parallel_data;
    wire byte_packed;
    wire [15:0] min_distance_angle;
    wire [15:0] max_distance_angle;
    wire [15:0] obs_alert;
    wire sendData;
    wire [1:0]headCheck;
     wire [7:0] CT;
     wire [15:0] FSA,LSA;
      wire [2:0] counter1;
     wire [7:0] counter2;
     wire [15:0] min_distance,max_distance,AtHand;
     wire sendingDone;
     wire [2:0] steps;
     wire extraCounter;
     wire [2:0] quo_rem_reg;
     wire busy;
     wire receiveDataPliz;
     wire [15:0] min_distance_angle_local;
     wire TxD_reset;
     wire [1:0] state;
     wire startTheSending;
     wire baud_clk;

    assign reset1 = reset;
    // Instantiate DUT
    topModule DUT (
        .clk(clk),
        .receiveData(receiveData),
        .transmitData(transmitData),
        .reset(reset1)
        // .parallel_data(parallel_data),
        // .byte_packed(byte_packed),
        // .min_distance_angle(min_distance_angle),
        // .max_distance_angle(max_distance_angle),
        // .obs_alert(obs_alert),
        // .sendData(sendData),
        // .headCheck(headCheck),
        // .CT(CT),
        // .LSA(LSA),
        // .FSA(FSA),
        // .counter1(counter1),
        // .counter2(counter2),
        // .min_distance(min_distance),
        // .max_distance(max_distance),
        // .AtHand(AtHand),
        // .sendingDone(sendingDone),
        // .steps(steps),
        // .quo_rem_reg(quo_rem_reg),
        // .busy(busy),
        // .receiveDataPliz(receiveDataPliz),
        // .min_distance_angle_local(min_distance_angle_local),
        // .TxD_reset(TxD_reset),
        // .state(state),
        // .startTheSending(startTheSending),
        // .baud_clk(baud_clk)
        // // .extraCounter(extraCounter)
    );

    // Clock generation: 100 MHz (10 ns period)
    initial begin
        clk = 0;
        reset = 1;
        #50 reset = 0;

        forever #5 clk = ~clk;  // 100 MHz
    end

    // UART parameters
    localparam BAUD_RATE   = 115200;
    localparam BIT_PERIOD  = 1_000_000_000 / BAUD_RATE; // ~8680 ns

    // UART transmitter task (to drive RxD input)
    task uart_send_byte(input [7:0] data);
        integer i;
        begin
            // Start bit
            receiveData = 0;
            #(BIT_PERIOD);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                receiveData = data[i];
                #(BIT_PERIOD);
            end

            // Stop bit
            receiveData = 1;
            #(BIT_PERIOD);
            #100;
        end
    endtask

    // Stimulus
    initial begin
        // Idle line high initially
        receiveData = 1;
        #100000; // wait 100 us for reset/stabilization

        // Send UART frames (goes into RxD inside DUT)
        uart_send_byte(8'h55);  // 01010101
        uart_send_byte(8'hAA);  // 10101010
        uart_send_byte(8'h21);  // 00001111
        uart_send_byte(8'hF6);  // 11110000
        uart_send_byte(8'h68);
        uart_send_byte(8'h0B);
        uart_send_byte(8'hB8);
        uart_send_byte(8'h94);
        uart_send_byte(8'hBC);
        uart_send_byte(8'h04);
        uart_send_byte(8'h28);
        uart_send_byte(8'hE2);
        uart_send_byte(8'h8D);
        uart_send_byte(8'hF1);
        uart_send_byte(8'hAB);
        uart_send_byte(8'h36);
        uart_send_byte(8'h32);
        uart_send_byte(8'h01);
        uart_send_byte(8'hAD);
        uart_send_byte(8'hB7);
        uart_send_byte(8'h4C);
        uart_send_byte(8'hDB);
        uart_send_byte(8'h86);
        uart_send_byte(8'h44);
        uart_send_byte(8'h18);
        uart_send_byte(8'hBD);
        uart_send_byte(8'hE6);
        uart_send_byte(8'h7D);
        uart_send_byte(8'hF3);
        uart_send_byte(8'h01);
        uart_send_byte(8'h3B);
        uart_send_byte(8'h23);
        uart_send_byte(8'h0D);
        uart_send_byte(8'h01);
        uart_send_byte(8'hB2);
        uart_send_byte(8'h00);
        uart_send_byte(8'h96);
        uart_send_byte(8'hE7);
        uart_send_byte(8'h3A);
        uart_send_byte(8'hA6);
        uart_send_byte(8'h0B);
        uart_send_byte(8'h03);
        uart_send_byte(8'hED);
        uart_send_byte(8'h02);
        uart_send_byte(8'hCA);
        uart_send_byte(8'h79);
        uart_send_byte(8'hC0);
        uart_send_byte(8'h03);
        uart_send_byte(8'h8B);
        uart_send_byte(8'hBA);
        uart_send_byte(8'h72);
        uart_send_byte(8'h00);
        uart_send_byte(8'hE4);
        uart_send_byte(8'h03);
        uart_send_byte(8'hA1);
        uart_send_byte(8'h5E);
        uart_send_byte(8'h99);
        uart_send_byte(8'h17);
        uart_send_byte(8'hFC);
        uart_send_byte(8'h2A);
        uart_send_byte(8'h25);
        uart_send_byte(8'h00);
        uart_send_byte(8'h62);
        uart_send_byte(8'h01);
        uart_send_byte(8'hB7);
        uart_send_byte(8'h80);
        uart_send_byte(8'h45);
        uart_send_byte(8'h3C);
        uart_send_byte(8'h49);
        uart_send_byte(8'h02);
        uart_send_byte(8'h3E);


        // wait for processing and TxD output
        #2000000;

        $finish;
    end

    // Dump VCD for GTKWave
    initial begin
        $dumpfile("tb_topModule.vcd");
        $dumpvars(0, tb_topModule);
    end

endmodule