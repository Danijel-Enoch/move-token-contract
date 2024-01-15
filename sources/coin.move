// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// Example coin with a trusted manager responsible for minting/burning (e.g., a stablecoin)
/// By convention, modules defining custom coin types use upper case names, in contrast to
/// ordinary modules, which use camel case.
module sui_coin::troll {
    use std::option;
    use sui::coin;
    use sui::url;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// Name of the coin. By convention, this type has the same name as its parent module
    /// and has no fields. The full type of the coin defined by this module will be `COIN<MANAGED>`.
    struct TROLL has drop {}

    /// Register the managed currency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: TROLL, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction sender
        let (treasury_cap, metadata) = coin::create_currency<TROLL>(witness, 9, b"TR", b"TRn", b"Tr", option::some(url::new_unsafe_from_bytes(b"https://res.cloudinary.com/daniel23/image/upload/v1705188555/WhatsApp_Image_2024-01-13_at_23.58.45_ypsuqz.jpg")), ctx);
        transfer::public_freeze_object(metadata);
        coin::mint_and_transfer(&mut treasury_cap, 1000000000000000000, tx_context::sender(ctx), ctx);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(TROLL {}, ctx)
    }
}