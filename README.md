
## GrowthVault: Secure Legacy Vault Smart Contract# GrowthVault: Secure Legacy Vault Smart Contract

## Introduction

GrowthVault is a secure legacy vault smart contract built on the Stacks blockchain using Clarity. It provides a robust solution for digital asset inheritance, allowing users to securely store and transfer their crypto assets based on inactivity periods. GrowthVault incorporates features such as multi-signature requirements, encrypted messages, and activity monitoring to ensure a secure and flexible inheritance process.

## Features

1. **Inactivity-Based Asset Transfer**
   - Users can deposit NFTs, tokens, or data into their vault.
   - Assets are automatically transferred to designated beneficiaries if the user remains inactive for a specified period.

2. **Multi-Signature Unlock Requirement**
   - Implements multi-signature functionality for authorizing access to the vault.
   - Multiple trusted parties can sign to execute the transfer in the absence of the original user.

3. **User-Specified Inheritance Rules**
   - Users can set their own inheritance rules, including:
     - Designated beneficiaries
     - Inactivity period before transfer
     - Required number of signatures for transfer

4. **Periodic Activity Alerts**
   - Sends periodic alerts to remind users to confirm their activity.
   - Helps prevent accidental inheritance triggers due to oversight.

5. **Encrypted Message Vault**
   - Allows users to store encrypted messages within the vault.
   - Messages become accessible to beneficiaries upon asset transfer.
   - Provides a way to leave personal messages, guidance, or instructions along with the inheritance.

6. **Activity Monitor Reset Functionality**
   - Users can actively confirm their presence and reset the inactivity timer.
   - Reduces the chance of unintentional asset transfer.
   - Allows users to maintain control over their assets with minimal effort.

7. **Secure Asset Management**
   - Limits the number of assets and messages that can be stored to prevent abuse.
   - Implements proper error handling and authorization checks throughout the contract.


## Usage

Here are some examples of how to interact with the GrowthVault smart contract:

1. Initialize a vault:
```clarity
(contract-call? .growth-vault initialize-vault 
  (list 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
  u31536000  ;; 1 year inactivity period
  u2          ;; 2 signatures required
  u2592000    ;; 30 days alert period
)

```

2. Deposit an asset:

```plaintext
 (contract-call? .growth-vault deposit-asset 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.my-nft)(contract-call? .growth-vault deposit-asset 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.my-nft)

```


3. Add an encrypted message:

```plaintext
 (contract-call? .growth-vault add-encrypted-message "encrypted-message-string")(contract-call? .growth-vault add-encrypted-message "encrypted-message-string")

```


4. Reset activity monitor:

```plaintext
 (contract-call? .growth-vault reset-activity-monitor)(contract-call? .growth-vault reset-activity-monitor)

```


5. Initiate a transfer (for authorized signers):

```plaintext
 (contract-call? .growth-vault initiate-transfer 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)(contract-call? .growth-vault initiate-transfer 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

```


## Security Considerations

- Ensure that you keep your private keys secure and do not share them with unauthorized parties.
- Regularly check and update your activity status to prevent unintended transfers.
- Choose trusted parties as authorized signers for your vault.
- Use strong encryption for any messages stored in the vault.


## Contributing

Contributions to GrowthVault are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to your branch
5. Create a new Pull Request


