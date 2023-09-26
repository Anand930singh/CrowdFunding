# Crowdfunding Smart Contract

This Solidity smart contract allows users to create and participate in crowdfunding campaigns. It enables contributors to fund a campaign, the owner to withdraw funds if the campaign is successful, and contributors to withdraw their contributions if the campaign fails to reach its goal.

## Contract Overview

- **Owner:** The Ethereum address of the campaign creator.
- **Name:** The name of the crowdfunding campaign.
- **Target Funds:** The total amount of Ether the campaign aims to raise.
- **Deadline:** The deadline for reaching the campaign's funding goal.
- **Funds Withdrawn:** A flag indicating whether funds have been withdrawn by the owner.

## Functions

### Constructor

The constructor initializes the crowdfunding campaign with the following parameters:

- `name` (string): The name of the campaign.
- `targetFunds` (uint256): The target amount of Ether to raise.
- `deadline` (uint256): The deadline for the campaign.

### `fund()`

Allows contributors to fund the campaign by sending Ether. The function records the contribution and emits a `Funded` event.

### `withdrawOwner()`

Only the campaign owner can call this function to withdraw funds if the campaign is successful. The owner can access the funds after the campaign reaches its goal. The function transfers the funds to the owner and updates the `fundsWithdrawn` flag. It emits an `OwnerWithdraw` event.

### `withdrawFunder()`

Contributors can call this function to withdraw their contributions if the campaign is unsuccessful. If the campaign fails to reach its funding goal by the deadline, contributors can retrieve their contributed Ether. The function calculates the amount to send to the contributor, transfers the funds, resets their contribution to zero, and emits a `FunderWithdraw` event.

### `isFundEnabled()`

A helper function that checks if funding is currently enabled (the campaign is active and not withdrawn). It returns `true` if the campaign is still open and hasn't been withdrawn; otherwise, it returns `false`.

### `isFundSuccess()`

A helper function that checks if the campaign is successful (target funds reached or already withdrawn). It returns `true` if the campaign has reached or exceeded its funding goal or if the funds have already been withdrawn; otherwise, it returns `false`.

## Events

The contract emits the following events to log significant contract actions:

- `Funded`: Logs contributions made by contributors, including the contributor's address and the amount contributed.
- `OwnerWithdraw`: Logs withdrawals by the owner, indicating the amount withdrawn.
- `FunderWithdraw`: Logs withdrawals by contributors, indicating the contributor's address and the amount withdrawn.

## Usage

1. Deploy the contract by providing the owner's address, campaign name, target funds, and deadline.
2. Contributors can fund the campaign using the `fund()` function by sending Ether to the contract address.
3. The campaign owner can withdraw funds using the `withdrawOwner()` function once the campaign reaches its funding goal.
4. Contributors can withdraw their contributions using the `withdrawFunder()` function if the campaign fails to meet its funding goal by the deadline.

## License

This smart contract is licensed under the MIT License.

