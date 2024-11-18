use dep::aztec::protocol_types::{address::AztecAddress, traits::{Serialize, Deserialize}};

global ESCROW_DEFINITION_LENGTH: u32 = 3;
global CONVERSION_RATE_DECIMALS = 6;

pub struct EscrowDefinition {
    commitment: Field,
    conversion_rate: Field,
    owner: AztecAddress
}

impl Serialize<ESCROW_DEFINITION_LENGTH> for EscrowDefinition {
    fn serialize(self: Self) -> [Field; ESCROW_DEFINITION_LENGTH] {
        [self.commitment, self.conversion_rate, self.owner.to_field()]
    }
}

impl Deserialize<ESCROW_DEFINITION_LENGTH> for EscrowDefinition {
    fn deserialize(fields: [Field; ESCROW_DEFINITION_LENGTH]) -> Self {
        EscrowDefinition {
            commitment: fields[0],
            conversion_rate: fields[1],
            owner: AztecAddress::from_field(fields[2]),
        }
    }
}

impl EscrowDefinition {
    /**
     * Create a new definition for a OpenZank escrow contract
     *
     * @param commitment - hash of sort code, BAN, and currency code
     * @param owner - The address of the escrow contract
     * @return The new escrow definition
     */
    pub fn new(commitment: Field, conversion_rate: Field, owner: AztecAddress) -> Self {
        EscrowDefinition { commitment, conversion_rate, owner }
    }
}