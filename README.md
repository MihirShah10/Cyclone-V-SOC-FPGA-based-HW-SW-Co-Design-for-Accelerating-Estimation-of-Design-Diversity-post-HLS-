
• After doing High Level Synthesis, we can generate multiple copies of the gate level netlist based on Area-Latency
constraints.
• There are certain IC’s which are mission critical and hence redundancy is added by creating a duplex or quadruple etc.
system which comprise of multiple such synthesized design copies (structurally different but functionally same).
• Now, in order to identify which combination of design leads to more diversity on-Chip, it is important to perform
certain tests (which in real world would be Common Mode Failures caused due to power fluctuations, electromagnetic
interferences etc. ) and thereby estimated the robustness of such mission critical IC’s.
• Through the help of D-Metric proposed by Dr. Subhashish Mitra (Stanford's Robust Systems Group), we can identify
such potential designs that can be implemented on the system, using a mathematical approach
