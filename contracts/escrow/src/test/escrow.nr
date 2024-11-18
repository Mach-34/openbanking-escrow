use crate::{OpenZankEscrow, test::utils::token_helpers::{check_public_balance, mint_public, to_usdc_decimals}};
use dep::aztec::{
    protocol_types::address::AztecAddress,
    test::helpers::{cheatcodes, test_environment::TestEnvironment}
};
use dep::token::Token;

global USDC_NAME = "Aztec USDC\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
global USDC_SYMBOL = "USDC.e\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
global USDC_DECIMALS: u8 = 6;

#[test]
unconstrained fn claim_open_bank_payment() {
    let mut env = TestEnvironment::new();
    let superuser = env.create_account();
    let claimmant = env.create_account();

    // deploy token contract
    let usdc_address = deploy_token_contract(&mut env, superuser);
    // deploy escrow contract
    let escrow_address = deploy_escrow_contract(&mut env, superuser, usdc_address);

    // mint 1,000,000 USDC to escrow contract
    let mint_amount = to_usdc_decimals(1000000);
    mint_public(&mut env, usdc_address, superuser, escrow_address, mint_amount);


}

/**
 * Deploy an escrow contract
 * 
 * @param env - The test environment
 * @param deployer - The address of the account deploying the contract\\
 * @param token_address - The address of the token contract
 * @return The deployed escrow contract
 */
unconstrained pub fn deploy_escrow_contract(
    env: &mut TestEnvironment,
    deployer: AztecAddress,
    token_address: AztecAddress,
) -> AztecAddress {
    env.impersonate(deployer);

    // initialize dummy data
    let commitment: Field = 101010;
    let conversion_rate = 160000;

    let escrow_init_call_iface = OpenZankEscrow::interface().constructor(
        commitment,
        conversion_rate,
        token_address,
    );
    let escrow_contract = env
        .deploy("./@escrow", "OpenZankEscrow")
        .with_public_void_initializer(escrow_init_call_iface);
    cheatcodes::advance_blocks_by(1);
    escrow_contract.to_address()
}

/**
 * Deploy a token contract
 * 
 * @param env - The test environment
 * @param deployer - The address of the account deploying the contract
 * @return The deployed token contract
 */
unconstrained pub fn deploy_token_contract(
    env: &mut TestEnvironment,
    deployer: AztecAddress
) -> AztecAddress {
    env.impersonate(deployer);

    let token_init_call_iface = Token::interface().constructor(
        deployer,
        USDC_NAME,
        USDC_SYMBOL,
        USDC_DECIMALS
    );
    let token_contract = env
        .deploy("./@token_contract", "Token")
        .with_public_void_initializer(token_init_call_iface);

    cheatcodes::advance_blocks_by(1);

    token_contract.to_address()
}