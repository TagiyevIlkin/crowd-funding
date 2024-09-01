This Solidity smart contract, CrowdFunding, implements a decentralized crowdfunding platform where contributors can fund projects, and the collected funds are managed by an admin. The key features of the contract include:

Key Features
  Contributions: Allows users to contribute funds to the campaign, with a minimum contribution requirement.
  Refunds: If the funding goal is not met by the deadline, contributors can request refunds of their contributions.
  Requests for Spending: The admin can create spending requests that describe how the collected funds will be used.
  Voting Mechanism: Contributors can vote on spending requests to approve or reject them. A request is approved if more than 50% of the 
  contributors vote in favor.
  Payment Execution: Once a spending request is approved, the admin can execute the payment to the specified recipient.

Contract Functions
  contribute(): Allows users to contribute to the crowdfunding campaign.
  getBalance(): Returns the current balance of the contract.
  getRefund(): Refunds contributors if the campaign fails to meet its goal by the deadline.
  createRequest(): Creates a new spending request (admin-only).
  voteRequest(): Allows contributors to vote on spending requests.
  makePayment(): Executes the payment for an approved request (admin-only).

Events
  ContributeEvent: Emitted when a user contributes to the campaign.
  CreateRequest: Emitted when a new spending request is created.
  MakePayment: Emitted when a payment is successfully made for an approved request.

Usage
This contract facilitates a transparent and decentralized approach to crowdfunding, ensuring that funds are only used as approved by a majority of contributors. It allows contributors to actively participate in decision-making regarding the use of their contributions, promoting trust and accountability in the funding process.
