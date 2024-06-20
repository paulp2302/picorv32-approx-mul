# Problem

In many embedded systems, efficient data processing is crucial as these systems often have stringent requirements for energy consumption and processing speed. However, performing exact multiplications ensures high accuracy but at the cost of increased power consumption and potentially higher latency.

# Solution

Approximate multiplying provides a valuable approach for improving the efficiency of computationally intensive tasks like image or video processing and filtering noisy sensor signals. By leveraging the capabilities of the Icebreaker FPGA, we can prototype and evaluate these methods, achieving a balance between performance and resource usage. This approach is particularly useful in power-constrained, real-time applications where some accuracy can be sacrificed for greater efficiency.

# Required Tools

- iCEbreaker FPGA board
- [modified PicoRV32 Repository](https://github.com/sevjaeg/picorv32) (already included)

# Reproducing the Code

// make help text

# Performance Results

| Metric                    | Benchmarks |
|---------------------------|------------|
| Resource Consumption      |            |
| Clock Frequency           |            |
| Cycles per Multiplication |            |
| Max. Multiplication Error |            |

# Credits

**Students**:
- Paul Pölzl
- Samir Hodzic
- Veronica Kimelman

**Supervisors**:
- Christian Krieg
- Stefan Bajtala

**PicoRV32**:
- Yosys ([Link](https://github.com/YosysHQ/picorv32))
- Modified by Severin ([Link](https://github.com/sevjaeg/picorv32))

**Golden Model** (Reference):
- Stefan Bajtala ([Link](https://github.com/SteBaj/LDISPython))
