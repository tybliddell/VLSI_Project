# VLSI_Project
This repo is for our Fall 2022 VLSI group project at the University of Utah. We designed a 256-byte direct mapped cache and a cache controller that uses a snooping-based coherence mechanism with a write-update coherence protocol. The project was designed in Verilog and brought all the way to tape out using a TSMC 180 nm design library. Testbenches were created to test individual modules as well as the entire system. 

# Members:
Tyler Liddell\
McKay Mower\
Braxton Chappell 

# Instructions
Include the following files in a modelsim project:

-src/cache.v\
-src/cache_coherenter.v\
-src/input_collector.v\
-src/output_emitter.v\
-src/top_level.v\
-src/macros.vh\
\
-tb/cache_coherenter_tb.v\
-tb/collector_emitter_tb.v\
-tb/top_level_tb.v\
-tb/cache_tb.v

Each of the testbenches may be run individually. The output will indicate if it completed with or without errors.
