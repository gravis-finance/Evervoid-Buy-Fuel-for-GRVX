# Gravis Finance Buy fuel for GRVX 

This contract is used in the Evervoid application.

URL where the contract is used: https://evervo.id/resources/buy-fuel

The production address of the contract on the network:

BSC: https://bscscan.com/address/0x211f14bf5b68553727cee0cf3f2707b5c2f19191

Polygon: https://polygonscan.com/address/0x7221f99110db5f7b5aa72eba847fc642d226cad5



## Setup

### Compile

Copy `example.env` to a new file called `.env` and fill the values in it.

```
npx hardhat compile
```

### Deploy

```
npx hardhat run scripts/deploy.ts --network [Your Network]
```

## Burner Functions

### Burn GRVX

This primary function is used to burn GRVX for fuel. Before calling, approval for spending required amount of GRVX should be given.

```jsx
function burnGRVX(uint256 amount)
```

**Parameters**

-   uint256 amount - Amount of grvx that sender wants to burn

### Change burner status

This function is restricted to owner and is used to change contract's status

```jsx
function changeStatus(bool status)
```

**Parameters**

-   bool status - Wherever contract should be active(true) or paused(false)
