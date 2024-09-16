// nios_security.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module nios_security (
		input  wire        clk_clk,       //   clk.clk
		output wire [31:0] led_export,    //   led.export
		input  wire        reset_reset_n, // reset.reset_n
		output wire [31:0] stop_export,   //  stop.export
		input  wire        uart1_rxd,     // uart1.rxd
		output wire        uart1_txd      //      .txd
	);

	wire  [31:0] niosii_data_master_readdata;                          // mm_interconnect_0:NIOSII_data_master_readdata -> NIOSII:d_readdata
	wire         niosii_data_master_waitrequest;                       // mm_interconnect_0:NIOSII_data_master_waitrequest -> NIOSII:d_waitrequest
	wire         niosii_data_master_debugaccess;                       // NIOSII:debug_mem_slave_debugaccess_to_roms -> mm_interconnect_0:NIOSII_data_master_debugaccess
	wire  [18:0] niosii_data_master_address;                           // NIOSII:d_address -> mm_interconnect_0:NIOSII_data_master_address
	wire   [3:0] niosii_data_master_byteenable;                        // NIOSII:d_byteenable -> mm_interconnect_0:NIOSII_data_master_byteenable
	wire         niosii_data_master_read;                              // NIOSII:d_read -> mm_interconnect_0:NIOSII_data_master_read
	wire         niosii_data_master_write;                             // NIOSII:d_write -> mm_interconnect_0:NIOSII_data_master_write
	wire  [31:0] niosii_data_master_writedata;                         // NIOSII:d_writedata -> mm_interconnect_0:NIOSII_data_master_writedata
	wire  [31:0] niosii_instruction_master_readdata;                   // mm_interconnect_0:NIOSII_instruction_master_readdata -> NIOSII:i_readdata
	wire         niosii_instruction_master_waitrequest;                // mm_interconnect_0:NIOSII_instruction_master_waitrequest -> NIOSII:i_waitrequest
	wire  [18:0] niosii_instruction_master_address;                    // NIOSII:i_address -> mm_interconnect_0:NIOSII_instruction_master_address
	wire         niosii_instruction_master_read;                       // NIOSII:i_read -> mm_interconnect_0:NIOSII_instruction_master_read
	wire         mm_interconnect_0_jtag_avalon_jtag_slave_chipselect;  // mm_interconnect_0:JTAG_avalon_jtag_slave_chipselect -> JTAG:av_chipselect
	wire  [31:0] mm_interconnect_0_jtag_avalon_jtag_slave_readdata;    // JTAG:av_readdata -> mm_interconnect_0:JTAG_avalon_jtag_slave_readdata
	wire         mm_interconnect_0_jtag_avalon_jtag_slave_waitrequest; // JTAG:av_waitrequest -> mm_interconnect_0:JTAG_avalon_jtag_slave_waitrequest
	wire   [0:0] mm_interconnect_0_jtag_avalon_jtag_slave_address;     // mm_interconnect_0:JTAG_avalon_jtag_slave_address -> JTAG:av_address
	wire         mm_interconnect_0_jtag_avalon_jtag_slave_read;        // mm_interconnect_0:JTAG_avalon_jtag_slave_read -> JTAG:av_read_n
	wire         mm_interconnect_0_jtag_avalon_jtag_slave_write;       // mm_interconnect_0:JTAG_avalon_jtag_slave_write -> JTAG:av_write_n
	wire  [31:0] mm_interconnect_0_jtag_avalon_jtag_slave_writedata;   // mm_interconnect_0:JTAG_avalon_jtag_slave_writedata -> JTAG:av_writedata
	wire  [31:0] mm_interconnect_0_id_control_slave_readdata;          // ID:readdata -> mm_interconnect_0:ID_control_slave_readdata
	wire   [0:0] mm_interconnect_0_id_control_slave_address;           // mm_interconnect_0:ID_control_slave_address -> ID:address
	wire  [31:0] mm_interconnect_0_niosii_debug_mem_slave_readdata;    // NIOSII:debug_mem_slave_readdata -> mm_interconnect_0:NIOSII_debug_mem_slave_readdata
	wire         mm_interconnect_0_niosii_debug_mem_slave_waitrequest; // NIOSII:debug_mem_slave_waitrequest -> mm_interconnect_0:NIOSII_debug_mem_slave_waitrequest
	wire         mm_interconnect_0_niosii_debug_mem_slave_debugaccess; // mm_interconnect_0:NIOSII_debug_mem_slave_debugaccess -> NIOSII:debug_mem_slave_debugaccess
	wire   [8:0] mm_interconnect_0_niosii_debug_mem_slave_address;     // mm_interconnect_0:NIOSII_debug_mem_slave_address -> NIOSII:debug_mem_slave_address
	wire         mm_interconnect_0_niosii_debug_mem_slave_read;        // mm_interconnect_0:NIOSII_debug_mem_slave_read -> NIOSII:debug_mem_slave_read
	wire   [3:0] mm_interconnect_0_niosii_debug_mem_slave_byteenable;  // mm_interconnect_0:NIOSII_debug_mem_slave_byteenable -> NIOSII:debug_mem_slave_byteenable
	wire         mm_interconnect_0_niosii_debug_mem_slave_write;       // mm_interconnect_0:NIOSII_debug_mem_slave_write -> NIOSII:debug_mem_slave_write
	wire  [31:0] mm_interconnect_0_niosii_debug_mem_slave_writedata;   // mm_interconnect_0:NIOSII_debug_mem_slave_writedata -> NIOSII:debug_mem_slave_writedata
	wire         mm_interconnect_0_uart1_s1_chipselect;                // mm_interconnect_0:UART1_s1_chipselect -> UART1:chipselect
	wire  [15:0] mm_interconnect_0_uart1_s1_readdata;                  // UART1:readdata -> mm_interconnect_0:UART1_s1_readdata
	wire   [2:0] mm_interconnect_0_uart1_s1_address;                   // mm_interconnect_0:UART1_s1_address -> UART1:address
	wire         mm_interconnect_0_uart1_s1_read;                      // mm_interconnect_0:UART1_s1_read -> UART1:read_n
	wire         mm_interconnect_0_uart1_s1_begintransfer;             // mm_interconnect_0:UART1_s1_begintransfer -> UART1:begintransfer
	wire         mm_interconnect_0_uart1_s1_write;                     // mm_interconnect_0:UART1_s1_write -> UART1:write_n
	wire  [15:0] mm_interconnect_0_uart1_s1_writedata;                 // mm_interconnect_0:UART1_s1_writedata -> UART1:writedata
	wire         mm_interconnect_0_ram_s1_chipselect;                  // mm_interconnect_0:RAM_s1_chipselect -> RAM:chipselect
	wire  [31:0] mm_interconnect_0_ram_s1_readdata;                    // RAM:readdata -> mm_interconnect_0:RAM_s1_readdata
	wire  [14:0] mm_interconnect_0_ram_s1_address;                     // mm_interconnect_0:RAM_s1_address -> RAM:address
	wire   [3:0] mm_interconnect_0_ram_s1_byteenable;                  // mm_interconnect_0:RAM_s1_byteenable -> RAM:byteenable
	wire         mm_interconnect_0_ram_s1_write;                       // mm_interconnect_0:RAM_s1_write -> RAM:write
	wire  [31:0] mm_interconnect_0_ram_s1_writedata;                   // mm_interconnect_0:RAM_s1_writedata -> RAM:writedata
	wire         mm_interconnect_0_ram_s1_clken;                       // mm_interconnect_0:RAM_s1_clken -> RAM:clken
	wire         mm_interconnect_0_stop_s1_chipselect;                 // mm_interconnect_0:STOP_s1_chipselect -> STOP:chipselect
	wire  [31:0] mm_interconnect_0_stop_s1_readdata;                   // STOP:readdata -> mm_interconnect_0:STOP_s1_readdata
	wire   [1:0] mm_interconnect_0_stop_s1_address;                    // mm_interconnect_0:STOP_s1_address -> STOP:address
	wire         mm_interconnect_0_stop_s1_write;                      // mm_interconnect_0:STOP_s1_write -> STOP:write_n
	wire  [31:0] mm_interconnect_0_stop_s1_writedata;                  // mm_interconnect_0:STOP_s1_writedata -> STOP:writedata
	wire         mm_interconnect_0_led_s1_chipselect;                  // mm_interconnect_0:LED_s1_chipselect -> LED:chipselect
	wire  [31:0] mm_interconnect_0_led_s1_readdata;                    // LED:readdata -> mm_interconnect_0:LED_s1_readdata
	wire   [1:0] mm_interconnect_0_led_s1_address;                     // mm_interconnect_0:LED_s1_address -> LED:address
	wire         mm_interconnect_0_led_s1_write;                       // mm_interconnect_0:LED_s1_write -> LED:write_n
	wire  [31:0] mm_interconnect_0_led_s1_writedata;                   // mm_interconnect_0:LED_s1_writedata -> LED:writedata
	wire         irq_mapper_receiver0_irq;                             // UART1:irq -> irq_mapper:receiver0_irq
	wire         irq_mapper_receiver1_irq;                             // JTAG:av_irq -> irq_mapper:receiver1_irq
	wire  [31:0] niosii_irq_irq;                                       // irq_mapper:sender_irq -> NIOSII:irq
	wire         rst_controller_reset_out_reset;                       // rst_controller:reset_out -> [ID:reset_n, JTAG:rst_n, LED:reset_n, NIOSII:reset_n, RAM:reset, STOP:reset_n, UART1:reset_n, irq_mapper:reset, mm_interconnect_0:NIOSII_reset_reset_bridge_in_reset_reset, rst_translator:in_reset]
	wire         rst_controller_reset_out_reset_req;                   // rst_controller:reset_req -> [NIOSII:reset_req, RAM:reset_req, rst_translator:reset_req_in]
	wire         niosii_debug_reset_request_reset;                     // NIOSII:debug_reset_request -> rst_controller:reset_in1

	nios_security_ID id (
		.clock    (clk_clk),                                     //           clk.clk
		.reset_n  (~rst_controller_reset_out_reset),             //         reset.reset_n
		.readdata (mm_interconnect_0_id_control_slave_readdata), // control_slave.readdata
		.address  (mm_interconnect_0_id_control_slave_address)   //              .address
	);

	nios_security_JTAG jtag (
		.clk            (clk_clk),                                              //               clk.clk
		.rst_n          (~rst_controller_reset_out_reset),                      //             reset.reset_n
		.av_chipselect  (mm_interconnect_0_jtag_avalon_jtag_slave_chipselect),  // avalon_jtag_slave.chipselect
		.av_address     (mm_interconnect_0_jtag_avalon_jtag_slave_address),     //                  .address
		.av_read_n      (~mm_interconnect_0_jtag_avalon_jtag_slave_read),       //                  .read_n
		.av_readdata    (mm_interconnect_0_jtag_avalon_jtag_slave_readdata),    //                  .readdata
		.av_write_n     (~mm_interconnect_0_jtag_avalon_jtag_slave_write),      //                  .write_n
		.av_writedata   (mm_interconnect_0_jtag_avalon_jtag_slave_writedata),   //                  .writedata
		.av_waitrequest (mm_interconnect_0_jtag_avalon_jtag_slave_waitrequest), //                  .waitrequest
		.av_irq         (irq_mapper_receiver1_irq)                              //               irq.irq
	);

	nios_security_LED led (
		.clk        (clk_clk),                             //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),     //               reset.reset_n
		.address    (mm_interconnect_0_led_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_led_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_led_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_led_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_led_s1_readdata),   //                    .readdata
		.out_port   (led_export)                           // external_connection.export
	);

	nios_security_NIOSII niosii (
		.clk                                 (clk_clk),                                              //                       clk.clk
		.reset_n                             (~rst_controller_reset_out_reset),                      //                     reset.reset_n
		.reset_req                           (rst_controller_reset_out_reset_req),                   //                          .reset_req
		.d_address                           (niosii_data_master_address),                           //               data_master.address
		.d_byteenable                        (niosii_data_master_byteenable),                        //                          .byteenable
		.d_read                              (niosii_data_master_read),                              //                          .read
		.d_readdata                          (niosii_data_master_readdata),                          //                          .readdata
		.d_waitrequest                       (niosii_data_master_waitrequest),                       //                          .waitrequest
		.d_write                             (niosii_data_master_write),                             //                          .write
		.d_writedata                         (niosii_data_master_writedata),                         //                          .writedata
		.debug_mem_slave_debugaccess_to_roms (niosii_data_master_debugaccess),                       //                          .debugaccess
		.i_address                           (niosii_instruction_master_address),                    //        instruction_master.address
		.i_read                              (niosii_instruction_master_read),                       //                          .read
		.i_readdata                          (niosii_instruction_master_readdata),                   //                          .readdata
		.i_waitrequest                       (niosii_instruction_master_waitrequest),                //                          .waitrequest
		.irq                                 (niosii_irq_irq),                                       //                       irq.irq
		.debug_reset_request                 (niosii_debug_reset_request_reset),                     //       debug_reset_request.reset
		.debug_mem_slave_address             (mm_interconnect_0_niosii_debug_mem_slave_address),     //           debug_mem_slave.address
		.debug_mem_slave_byteenable          (mm_interconnect_0_niosii_debug_mem_slave_byteenable),  //                          .byteenable
		.debug_mem_slave_debugaccess         (mm_interconnect_0_niosii_debug_mem_slave_debugaccess), //                          .debugaccess
		.debug_mem_slave_read                (mm_interconnect_0_niosii_debug_mem_slave_read),        //                          .read
		.debug_mem_slave_readdata            (mm_interconnect_0_niosii_debug_mem_slave_readdata),    //                          .readdata
		.debug_mem_slave_waitrequest         (mm_interconnect_0_niosii_debug_mem_slave_waitrequest), //                          .waitrequest
		.debug_mem_slave_write               (mm_interconnect_0_niosii_debug_mem_slave_write),       //                          .write
		.debug_mem_slave_writedata           (mm_interconnect_0_niosii_debug_mem_slave_writedata),   //                          .writedata
		.dummy_ci_port                       ()                                                      // custom_instruction_master.readra
	);

	nios_security_RAM ram (
		.clk        (clk_clk),                             //   clk1.clk
		.address    (mm_interconnect_0_ram_s1_address),    //     s1.address
		.clken      (mm_interconnect_0_ram_s1_clken),      //       .clken
		.chipselect (mm_interconnect_0_ram_s1_chipselect), //       .chipselect
		.write      (mm_interconnect_0_ram_s1_write),      //       .write
		.readdata   (mm_interconnect_0_ram_s1_readdata),   //       .readdata
		.writedata  (mm_interconnect_0_ram_s1_writedata),  //       .writedata
		.byteenable (mm_interconnect_0_ram_s1_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset),      // reset1.reset
		.reset_req  (rst_controller_reset_out_reset_req),  //       .reset_req
		.freeze     (1'b0)                                 // (terminated)
	);

	nios_security_LED stop (
		.clk        (clk_clk),                              //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),      //               reset.reset_n
		.address    (mm_interconnect_0_stop_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_stop_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_stop_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_stop_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_stop_s1_readdata),   //                    .readdata
		.out_port   (stop_export)                           // external_connection.export
	);

	nios_security_UART1 uart1 (
		.clk           (clk_clk),                                  //                 clk.clk
		.reset_n       (~rst_controller_reset_out_reset),          //               reset.reset_n
		.address       (mm_interconnect_0_uart1_s1_address),       //                  s1.address
		.begintransfer (mm_interconnect_0_uart1_s1_begintransfer), //                    .begintransfer
		.chipselect    (mm_interconnect_0_uart1_s1_chipselect),    //                    .chipselect
		.read_n        (~mm_interconnect_0_uart1_s1_read),         //                    .read_n
		.write_n       (~mm_interconnect_0_uart1_s1_write),        //                    .write_n
		.writedata     (mm_interconnect_0_uart1_s1_writedata),     //                    .writedata
		.readdata      (mm_interconnect_0_uart1_s1_readdata),      //                    .readdata
		.rxd           (uart1_rxd),                                // external_connection.export
		.txd           (uart1_txd),                                //                    .export
		.irq           (irq_mapper_receiver0_irq)                  //                 irq.irq
	);

	nios_security_mm_interconnect_0 mm_interconnect_0 (
		.CLK_clk_clk                              (clk_clk),                                              //                            CLK_clk.clk
		.NIOSII_reset_reset_bridge_in_reset_reset (rst_controller_reset_out_reset),                       // NIOSII_reset_reset_bridge_in_reset.reset
		.NIOSII_data_master_address               (niosii_data_master_address),                           //                 NIOSII_data_master.address
		.NIOSII_data_master_waitrequest           (niosii_data_master_waitrequest),                       //                                   .waitrequest
		.NIOSII_data_master_byteenable            (niosii_data_master_byteenable),                        //                                   .byteenable
		.NIOSII_data_master_read                  (niosii_data_master_read),                              //                                   .read
		.NIOSII_data_master_readdata              (niosii_data_master_readdata),                          //                                   .readdata
		.NIOSII_data_master_write                 (niosii_data_master_write),                             //                                   .write
		.NIOSII_data_master_writedata             (niosii_data_master_writedata),                         //                                   .writedata
		.NIOSII_data_master_debugaccess           (niosii_data_master_debugaccess),                       //                                   .debugaccess
		.NIOSII_instruction_master_address        (niosii_instruction_master_address),                    //          NIOSII_instruction_master.address
		.NIOSII_instruction_master_waitrequest    (niosii_instruction_master_waitrequest),                //                                   .waitrequest
		.NIOSII_instruction_master_read           (niosii_instruction_master_read),                       //                                   .read
		.NIOSII_instruction_master_readdata       (niosii_instruction_master_readdata),                   //                                   .readdata
		.ID_control_slave_address                 (mm_interconnect_0_id_control_slave_address),           //                   ID_control_slave.address
		.ID_control_slave_readdata                (mm_interconnect_0_id_control_slave_readdata),          //                                   .readdata
		.JTAG_avalon_jtag_slave_address           (mm_interconnect_0_jtag_avalon_jtag_slave_address),     //             JTAG_avalon_jtag_slave.address
		.JTAG_avalon_jtag_slave_write             (mm_interconnect_0_jtag_avalon_jtag_slave_write),       //                                   .write
		.JTAG_avalon_jtag_slave_read              (mm_interconnect_0_jtag_avalon_jtag_slave_read),        //                                   .read
		.JTAG_avalon_jtag_slave_readdata          (mm_interconnect_0_jtag_avalon_jtag_slave_readdata),    //                                   .readdata
		.JTAG_avalon_jtag_slave_writedata         (mm_interconnect_0_jtag_avalon_jtag_slave_writedata),   //                                   .writedata
		.JTAG_avalon_jtag_slave_waitrequest       (mm_interconnect_0_jtag_avalon_jtag_slave_waitrequest), //                                   .waitrequest
		.JTAG_avalon_jtag_slave_chipselect        (mm_interconnect_0_jtag_avalon_jtag_slave_chipselect),  //                                   .chipselect
		.LED_s1_address                           (mm_interconnect_0_led_s1_address),                     //                             LED_s1.address
		.LED_s1_write                             (mm_interconnect_0_led_s1_write),                       //                                   .write
		.LED_s1_readdata                          (mm_interconnect_0_led_s1_readdata),                    //                                   .readdata
		.LED_s1_writedata                         (mm_interconnect_0_led_s1_writedata),                   //                                   .writedata
		.LED_s1_chipselect                        (mm_interconnect_0_led_s1_chipselect),                  //                                   .chipselect
		.NIOSII_debug_mem_slave_address           (mm_interconnect_0_niosii_debug_mem_slave_address),     //             NIOSII_debug_mem_slave.address
		.NIOSII_debug_mem_slave_write             (mm_interconnect_0_niosii_debug_mem_slave_write),       //                                   .write
		.NIOSII_debug_mem_slave_read              (mm_interconnect_0_niosii_debug_mem_slave_read),        //                                   .read
		.NIOSII_debug_mem_slave_readdata          (mm_interconnect_0_niosii_debug_mem_slave_readdata),    //                                   .readdata
		.NIOSII_debug_mem_slave_writedata         (mm_interconnect_0_niosii_debug_mem_slave_writedata),   //                                   .writedata
		.NIOSII_debug_mem_slave_byteenable        (mm_interconnect_0_niosii_debug_mem_slave_byteenable),  //                                   .byteenable
		.NIOSII_debug_mem_slave_waitrequest       (mm_interconnect_0_niosii_debug_mem_slave_waitrequest), //                                   .waitrequest
		.NIOSII_debug_mem_slave_debugaccess       (mm_interconnect_0_niosii_debug_mem_slave_debugaccess), //                                   .debugaccess
		.RAM_s1_address                           (mm_interconnect_0_ram_s1_address),                     //                             RAM_s1.address
		.RAM_s1_write                             (mm_interconnect_0_ram_s1_write),                       //                                   .write
		.RAM_s1_readdata                          (mm_interconnect_0_ram_s1_readdata),                    //                                   .readdata
		.RAM_s1_writedata                         (mm_interconnect_0_ram_s1_writedata),                   //                                   .writedata
		.RAM_s1_byteenable                        (mm_interconnect_0_ram_s1_byteenable),                  //                                   .byteenable
		.RAM_s1_chipselect                        (mm_interconnect_0_ram_s1_chipselect),                  //                                   .chipselect
		.RAM_s1_clken                             (mm_interconnect_0_ram_s1_clken),                       //                                   .clken
		.STOP_s1_address                          (mm_interconnect_0_stop_s1_address),                    //                            STOP_s1.address
		.STOP_s1_write                            (mm_interconnect_0_stop_s1_write),                      //                                   .write
		.STOP_s1_readdata                         (mm_interconnect_0_stop_s1_readdata),                   //                                   .readdata
		.STOP_s1_writedata                        (mm_interconnect_0_stop_s1_writedata),                  //                                   .writedata
		.STOP_s1_chipselect                       (mm_interconnect_0_stop_s1_chipselect),                 //                                   .chipselect
		.UART1_s1_address                         (mm_interconnect_0_uart1_s1_address),                   //                           UART1_s1.address
		.UART1_s1_write                           (mm_interconnect_0_uart1_s1_write),                     //                                   .write
		.UART1_s1_read                            (mm_interconnect_0_uart1_s1_read),                      //                                   .read
		.UART1_s1_readdata                        (mm_interconnect_0_uart1_s1_readdata),                  //                                   .readdata
		.UART1_s1_writedata                       (mm_interconnect_0_uart1_s1_writedata),                 //                                   .writedata
		.UART1_s1_begintransfer                   (mm_interconnect_0_uart1_s1_begintransfer),             //                                   .begintransfer
		.UART1_s1_chipselect                      (mm_interconnect_0_uart1_s1_chipselect)                 //                                   .chipselect
	);

	nios_security_irq_mapper irq_mapper (
		.clk           (clk_clk),                        //       clk.clk
		.reset         (rst_controller_reset_out_reset), // clk_reset.reset
		.receiver0_irq (irq_mapper_receiver0_irq),       // receiver0.irq
		.receiver1_irq (irq_mapper_receiver1_irq),       // receiver1.irq
		.sender_irq    (niosii_irq_irq)                  //    sender.irq
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (2),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                     // reset_in0.reset
		.reset_in1      (niosii_debug_reset_request_reset),   // reset_in1.reset
		.clk            (clk_clk),                            //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),     // reset_out.reset
		.reset_req      (rst_controller_reset_out_reset_req), //          .reset_req
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

endmodule
