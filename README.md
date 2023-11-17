# FPGA Vending Machine Project

This project simulates a vending machine using VHDL for FPGA development.

## Project Overview

The vending machine has the following features:
- Multiple snack options with different prices.
- Accepts both cash and card payments.
- Change calculation and dispensation for cash payments.
- Seven-segment display to show snack choices, prices, and change.
- State machine-based control for seamless operation.

## File Structure

- `constants_and_types.vhd`: Contains constants, types, and states used in the project.
- `snack_selector.vhd`: Module for snack selection.
- `payment_processor.vhd`: Module for handling payments and calculating change.
- `state_machine.vhd`: Controls the vending machine's states.
- `display_controller.vhd`: Manages the seven-segment display based on the machine's state.
- `seven_segment_encoder.vhd`: Converts binary inputs to seven-segment display outputs.
- `main_controller.vhd`: Integrates all modules and manages overall operation.

## How It Works

1. **Snack Selection**: Users select snacks using switches. Each snack has it's own price. Numer of item is displayed on 7-segment leds as well as the price.
2. **Payment**: Payment can be made either by cash (via switches) or card (simulated with a button press).
3. **Processing**: The machine "processes" the payment and dispenses the snack.
4. **Change Dispensation**: If paid by cash and change is due, it's calculated and indicated.

## Hardware Setup

- **FPGA Board**: Cyclone V DE10
- **Inputs**: Switches and buttons for snack selection and payment.
- **Output**: Seven-segment displays for feedback.
