# Chainlinker - Crosschain Gateway Bridge

A unified hub for inter-blockchain communication built on Stacks blockchain using Clarity smart contracts.

## Overview

Chainlinker is a smart contract designed to manage and track blockchain networks, bridges, and facilitate cross-network asset transfers. It provides a standardized interface for administrators to register new blockchain networks, configure bridge mechanisms, and monitor operational statuses.

## Features

- **Network Registry**: Track supported blockchain networks with unique identifiers
- **Bridge Management**: Register and manage bridge agents with different bridging mechanisms
- **Operational Status**: Monitor and update the operational status of networks and bridges
- **Flexible Bridging Mechanisms**: Support for multiple bridging approaches (validator, relay, merkle proof)

## Contract Structure

The contract is organized into several key components:

### Data Structures

- **Network Directory**: Stores information about supported blockchains
- **Bridge Directory**: Stores information about network bridges and their mechanisms

### Core Functions

#### Network Management
- `track-network`: Register a new blockchain network
- `modify-network-mode`: Update the operational status of a network
- `fetch-network-data`: Retrieve information about a registered network
- `is-network-operational`: Check if a network is currently operational

#### Bridge Management
- `track-bridge`: Register a new bridge agent
- `modify-bridge-mode`: Update the operational status of a bridge
- `fetch-bridge-data`: Retrieve information about a registered bridge

### Constants and Validators

- **Modes**: operational, suspended, discontinued 
- **Mechanisms**: validator, relay, merkle
- Built-in validation for network IDs, labels, and principals

## Error Codes

- `ERR-UNAUTHORIZED (100)`: Caller is not authorized to perform the operation
- `ERR-DUPLICATE-ENTRY (101)`: Attempting to register an already existing entry
- `ERR-MISSING-ENTRY (102)`: Referenced entry does not exist
- `ERR-INVALID-NETWORK (103)`: Referenced network does not exist
- `ERR-INVALID-PARAMETER (104)`: Parameter fails validation checks
- `ERR-INVALID-PRINCIPAL (105)`: Principal fails validation checks

## Usage Examples

### Registering a New Network

```clarity
;; Register Ethereum as network ID 1
(contract-call? .chainlinker track-network u1 "Ethereum" 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Registering a Bridge

```clarity
;; Register a validator-based bridge for Ethereum
(contract-call? .chainlinker track-bridge 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG u1 "validator")
```

### Checking Network Status

```clarity
;; Check if Ethereum network is operational
(contract-call? .chainlinker is-network-operational u1)
```

### Modifying Bridge Status

```clarity
;; Suspend a bridge temporarily
(contract-call? .chainlinker modify-bridge-mode 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG "suspended")
```

## Security Considerations

- Only the contract administrator can perform administrative functions
- Principal validation prevents usage of zero addresses
- Network and bridge operational states are strictly controlled
- All input parameters are validated before processing

## Deployment

1. Clone this repository
2. Deploy using Clarinet or other Stacks deployment tools:

```bash
clarinet contract deploy --network testnet
```
