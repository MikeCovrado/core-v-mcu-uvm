// Copyright 2022-2023 Datum Technology Corporation
// All rights reserved.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This file contains sample code that demonstrates how to add an instance of the CORE-V MCU
// Sub-System UVM Environment to another UVM environment.
// NOTE: It is recommended to split up class member declaration and definition; these classes are all inline to keep
//       the example short.


`ifndef __MY_ENV_CFG_SV__
`define __MY_ENV_CFG_SV__


/**
 * Object encapsulating all configuration information for my_env.
 */
class my_env_cfg_c extends uvm_object;

   rand uvme_cvmcu_cfg_c  cvmcu_cfg; ///< Handle to cvmcu environment configuration

   `uvm_object_utils_begin(my_env_cfg_c)
      `uvm_field_object(cvmcu_cfg, UVM_DEFAULT)
   `uvm_object_utils_end

   /**
    * Rules for safe default options
    */
   constraint defaults_cons {
      soft cvmcu_cfg.enabled == 1;
   }

   /**
    * Creates sub-configuration objects
    */
   function new(uvm_component parent=null, string name="my_env");
      super.new(parent, name);
      cfg = uvme_cvmcu_cfg_c::type_id::create("cvmcu_cfg");
   endfunction : new

endclass : my_env_cfg_c


`endif // __MY_ENV_CFG_SV__


`ifndef __MY_ENV_CNTXT_SV__
`define __MY_ENV_CNTXT_SV__


/**
 * Object encapsulating all state variables for my_env.
 */
class my_env_cntxt_c extends uvm_object;

   uvme_cvmcu_cntxt_c  cvmcu_cntxt; ///< Handle to cvmcu environment context

   `uvm_object_utils_begin(my_env_cntxt_c)
      `uvm_field_object(cvmcu_cntxt, UVM_DEFAULT)
   `uvm_object_utils_end

   /**
    * Creates sub-context objects
    */
   function new(uvm_component parent=null, string name="my_env");
      super.new(parent, name);
      cntxt = uvme_cvmcu_cntxt_c::type_id::create("cvmcu_cntxt");
   endfunction : new

endclass : my_env_cntxt_c


`endif // __MY_ENV_CNTXT_SV__


`ifndef __MY_ENV_SV__
`define __MY_ENV_SV__


/**
 * Component encapsulating the environment.
 */
class my_env_c extends uvm_env;

   my_env_cfg_c    cfg  ; ///< Configuration handle.  Must be provided by component instantiating this environment.
   my_env_cntxt_c  cntxt; ///< Context handle.  Can be provided by component instantiating this environment.
   uvme_cvmcu_env_c  cvmcu_env; ///< CORE-V MCU environment instance.

   `uvm_component_utils_begin(my_env_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end

   /**
    * Default constructor.
    */
   function new(uvm_component parent=null, string name="my_env");
      super.new(parent, name);
   endfunction : new

   /**
    * 1. Ensures #cfg & #cntxt handles are not null
    * 2. Assigns #cfg and #cntxt handles
    * 3. Creates #cvmcu_env
    */
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      void'(uvm_config_db#(my_env_cfg_c)::get(this, "", "cfg", cfg));
      if (!cfg) begin
         `uvm_fatal("MY_ENV", "Configuration handle is null")
      end
      else begin
         `uvm_info("MY_ENV", $sformatf("Found configuration handle:\n%s", cfg.sprint()), UVM_DEBUG)
         void'(uvm_config_db#(my_env_cntxt_c)::get(this, "", "cntxt", cntxt));
         if (!cntxt) begin
            `uvm_info("MY_ENV", "Context handle is null; creating.", UVM_DEBUG)
            cntxt = my_env_cntxt_c::type_id::create("cntxt");
         end
         uvm_config_db#(my_env_cfg_c  )::set(this, "*", "cfg"  , cfg  );
         uvm_config_db#(my_env_cntxt_c)::set(this, "*", "cntxt", cntxt);
         uvm_config_db#(uvme_cvmcu_cfg_c  )::set(this, "cvmcu_env", "cfg"  , cfg  .cvmcu_cfg  );
         uvm_config_db#(uvme_cvmcu_cntxt_c)::set(this, "cvmcu_env", "cntxt", cntxt.cvmcu_cntxt);
         cvmcu_env = uvme_cvmcu_env_c::type_id::create("cvmcu_env", this);
         end
      end
   endfunction : build_phase

endclass : my_env_c


`endif // __MY_ENV_SV__