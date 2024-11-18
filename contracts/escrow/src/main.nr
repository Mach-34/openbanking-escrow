use aztec::macros::aztec;

mod test;
mod types;

#[aztec]
contract OpenZankEscrow {

use aztec::{
    macros::{
        functions::{private, public, internal, view, initializer},
        storage::storage
    },
    prelude::{SharedImmutable},
    protocol_types::address::AztecAddress,
};
use crate::types::escrow_definition::EscrowDefinition;
use dep::token::Token;

    #[storage]
    struct Storage<Context> {
        definition: SharedImmutable<EscrowDefinition, Context>,
        usdc: SharedImmutable<AztecAddress, Context>,
    }

    /**
     * Initialize the OpenZank contract by setting the owner and commitment
     *
     * @param registry The address of the Z-Imburse contract registry
     * @param usdc_token The address of the USDC token
     * @param title The title of the contract as a string of max length 60
     */
    #[public]
    #[initializer]
    fn constructor(commitment: Field, conversion_rate: Field, usdc: AztecAddress) {
        let definition = EscrowDefinition::new(commitment, conversion_rate, context.msg_sender());
        storage.definition.initialize(definition);
        storage.usdc.initialize(usdc);
    }

    #[private]
    fn claim(amount: Field, secret: Field) {
        // redeem shield
        let usdc = storage.usdc.read_private();
        Token::at(usdc).redeem_shield(context.msg_sender(), amount, secret);
    }

    #[private]
    fn withdraw(amount: Field, secret_hash: Field) {
        // verify JWT and extract data
        // let definition = storage.definition.read();

        // check computed commitment

        // apply conversion rate to amount

        // shield token amount
        let usdc = storage.usdc.read_private();
        Token::at(usdc).shield(context.this_address(), amount, secret_hash, 0);
    }
}