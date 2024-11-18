#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

## Adds the compiled token contract
get_token_contract_bytecode() {
    token_bytecode_path="./node_modules/@aztec/noir-contracts.js/artifacts/token_contract-Token.json"
    cp $token_bytecode_path "${CONTRACT_DIR}/target"
}

get_token_contract_bytecode