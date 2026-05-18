# Pipelined-RISC-Processor-Verilog
A 32-bit five-stage pipelined RISC processor implemented in Verilog HDL with hazard detection, forwarding, stalling, branching, and memory support.
Here is a professional `README.md` you can copy directly to GitHub:

````markdown
# Pipelined RISC Processor in Verilog

## Overview

This project implements a simple 32-bit pipelined RISC processor using Verilog HDL.  
The processor is designed based on a classic five-stage pipeline architecture and supports instruction execution with pipeline control mechanisms such as forwarding, hazard detection, stalling, branching, and memory access.

The project was developed as part of a Computer Architecture / Hardware Design course to demonstrate the internal structure and behavior of a pipelined processor.

---

## Features

- 32-bit RISC processor design
- Five-stage pipeline architecture
- Verilog HDL implementation
- Register file implementation
- Arithmetic Logic Unit (ALU)
- Control unit
- Data memory and instruction memory
- Pipeline registers between stages
- Hazard detection unit
- Forwarding unit
- Stall detection and pipeline control
- Branch and jump handling
- Load and store instruction support
- Logisim datapath design included
- Project report included

---

## Pipeline Stages

The processor follows the standard five-stage pipeline model:

1. **Instruction Fetch (IF)**  
   Fetches the instruction from instruction memory.

2. **Instruction Decode (ID)**  
   Decodes the instruction and reads register operands.

3. **Execute (EX)**  
   Performs ALU operations and calculates addresses.

4. **Memory Access (MEM)**  
   Reads from or writes to data memory.

5. **Write Back (WB)**  
   Writes the result back to the register file.

---

## Project Structure

```text
Pipelined-RISC-Processor-Verilog/
│
├── src/
│   ├── ALU.v
│   ├── Basic_component.v
│   ├── Controls.v
│   ├── Forwarding_Unit.v
│   ├── Hazard_Detection.v
│   ├── Kill Uint.v
│   ├── LDW_SDW.v
│   ├── Memory.v
│   ├── Pipline_Register.v
│   ├── R-File.v
│   ├── Round_And_Stall.v
│   ├── Sipliter.v
│   ├── Stages.v
│   ├── Stall_Detection.v
│   └── datapath.v
│
├── programs/
│   ├── input.txt
│   └── DataMem.txt
│
├── logisim/
│   └── Data_Path.circ
│
├── docs/
│   └── Arc_Report.pdf
│
├── README.md
└── .gitignore
````

---

## Main Components

### ALU

The ALU performs arithmetic and logical operations required by the processor, such as addition, subtraction, logical operations, and comparison operations.

### Register File

The register file stores the processor registers and allows reading from two registers and writing to one register during execution.

### Control Unit

The control unit generates the required control signals depending on the instruction opcode and function fields.

### Hazard Detection Unit

The hazard detection unit detects data hazards that cannot be solved directly by forwarding and inserts stalls when needed.

### Forwarding Unit

The forwarding unit reduces pipeline stalls by forwarding results from later pipeline stages to earlier stages when possible.

### Pipeline Registers

Pipeline registers are used between stages to store instruction data, control signals, and intermediate results.

### Memory Unit

The memory unit supports load and store operations using data memory.

---

## Supported Concepts

This processor demonstrates several important computer architecture concepts:

* Instruction pipelining
* Data hazards
* Control hazards
* Forwarding
* Pipeline stalling
* Branch handling
* Register write-back
* Memory access
* Modular hardware design using Verilog

---

## How to Run

You can simulate the Verilog files using any Verilog simulator, such as:

* ModelSim
* QuestaSim
* Icarus Verilog
* Vivado Simulator
* Xilinx ISE
* EDA Playground

### Example using Icarus Verilog

```bash
iverilog -o processor_sim src/*.v
vvp processor_sim
```

> Note: Depending on your simulator and file naming, you may need to compile the files in the correct order or rename files that contain spaces.

---

## Input Files

The project includes input files used by the processor simulation:

```text
programs/input.txt
programs/DataMem.txt
```

These files can be used to initialize instruction memory and data memory during simulation.

---

## Logisim Design

A Logisim datapath design is included in:

```text
logisim/Data_Path.circ
```

This file provides a visual representation of the processor datapath and can be opened using Logisim or Logisim Evolution.

---

## Documentation

The project report is available in:

```text
docs/Arc_Report.pdf
```

The report explains the processor architecture, datapath, control logic, pipeline behavior, and design decisions.

---

## Notes

Some source file names may contain spelling issues or spaces, such as:

```text
Pipline_Register.v
Sipliter.v
Kill Uint.v
```

For better project organization, these can be renamed later to:

```text
Pipeline_Register.v
Splitter.v
Kill_Unit.v
```

However, if you rename any file, make sure to update all references inside the project.

---

## Technologies Used

* Verilog HDL
* Logisim
* Digital logic design
* Computer architecture concepts
* Hardware simulation tools

---

## Learning Outcomes

Through this project, the following concepts were practiced:

* Designing a pipelined processor datapath
* Implementing control logic in Verilog
* Handling data and control hazards
* Using forwarding and stalling mechanisms
* Structuring a hardware design project
* Simulating and testing processor behavior

---

## Author

**Ahmad Zuhd**
Computer Engineering Student
Birzeit University

---

## License

This project is intended for educational purposes.

````

For GitHub, put this file in the main folder and name it exactly:

```text
README.md
````
