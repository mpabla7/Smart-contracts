A Token of Ice and Fire

Implemented my own ERC-20 token.

Support for freezing accounts
The contract creator has special power to freeze accounts, making the tokens unspendable.

freeze(address) -- Marks the given address as frozen.
thaw(address) -- Unmarks the given address as frozen.

Added support for burning tokens
Burning tokens destroys them forever.
`burn(uint)` function. It should destroy the specified number of tokens, if the caller has sufficient tokens.
