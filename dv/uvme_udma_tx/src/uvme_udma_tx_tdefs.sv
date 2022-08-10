// Copyright 2022 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_UDMA_TX_TDEFS_SV__
`define __UVME_UDMA_TX_TDEFS_SV__


// Scoreboard specialization
typedef uvml_sb_simplex_c #(
   .T_ACT_TRN(uvma_udma_tx_dp_out_mon_trn_c)
) uvme_udma_tx_sb_simplex_c;

// Add tdefs, enums and structs here
// Ex: typedef bit [(`UVME_UDMA_TX_ABC_MAX_WIDTH-1):0]  uvme_udma_tx_abc_b_t;
// Ex: typedef enum {
//        UVME_UDMA_TX_MY_ABC
//     } uvme_udma_tx_my_enum;
// Ex: typedef struct {
//        bit [2:0]  abc;
//        logic      xyz;
//     } uvme_udma_tx_my_struct;


`endif // __UVME_UDMA_TX_TDEFS_SV__
