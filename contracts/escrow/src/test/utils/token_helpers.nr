use crate::test::escrow::USDC_DECIMALS;
use dep::aztec::{
    oracle::{execution::{get_block_number, get_contract_address}, storage::storage_read},
    protocol_types::{address::AztecAddress, storage::map::derive_storage_slot_in_map},
    test::helpers::{cheatcodes, test_environment::TestEnvironment}
};
use dep::token::{Token, types::transparent_note::TransparentNote};

unconstrained pub fn check_public_balance(
    token_contract_address: AztecAddress,
    address: AztecAddress,
    address_amount: Field
) {
    let current_contract_address = get_contract_address();
    cheatcodes::set_contract_address(token_contract_address);
    let block_number = get_block_number();

    let balances_slot = Token::storage_layout().public_balances.slot;
    let address_slot = derive_storage_slot_in_map(balances_slot, address);
    let amount: U128 = storage_read(token_contract_address, address_slot, block_number);
    assert(amount.to_field() == address_amount, "Public balance is not correct");
    cheatcodes::set_contract_address(current_contract_address);
}


/**
 * Publicly mint tokens to a recipient (basically to the escrow contract)
 *
 * @param env - The test environment
 * @param token_address - The address of the token contract
 * @param escrow_address - The address of the escrow contract
 * @param amount - The amount of tokens to mint
 */
unconstrained pub fn mint_public(
    env: &mut TestEnvironment,
    token_address: AztecAddress,
    minter: AztecAddress,
    recipient: AztecAddress,
    amount: Field
) {
    env.impersonate(minter);
    Token::at(token_address).mint_public(recipient, amount).call(&mut env.public());
    cheatcodes::advance_blocks_by(1);
}

unconstrained pub fn to_usdc_decimals(amount: Field) -> Field {
    amount * 10.pow_32(USDC_DECIMALS as Field)
}
