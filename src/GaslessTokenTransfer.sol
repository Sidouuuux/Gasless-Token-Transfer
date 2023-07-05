// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./interfaces/IERC20Permit.sol";

/**
 * @title GaslessTokenTransfer
 * @dev A Solidity contract that allows gasless token transfers using the permit function from ERC20Permit standard.
 */
contract GaslessTokenTransfer {
      /**
     * @dev Sends tokens from the sender's address to the receiver's address while paying a fee for the transfer.
     * @param token The address of the ERC20 token contract.
     * @param sender The address of the sender, who approves the transfer from their account.
     * @param receiver The address of the receiver, who will receive the main token amount.
     * @param amount The amount of tokens to transfer to the receiver.
     * @param fee The fee amount to be paid by the sender to perform the transfer.
     * @param deadline The timestamp deadline for the permit signature to be considered valid.
     * @param v The signature recovery identifier.
     * @param r The "r" component of the ECDSA signature for the permit.
     * @param s The "s" component of the ECDSA signature for the permit.
     *
     * Requirements:
     * - The sender must have previously granted permission for this contract (GaslessTokenTransfer)
     *   to spend tokens on their behalf using the permit function.
     * - The permit signature provided (v, r, s) must be valid and not expired (deadline not passed).
     * - The amount and fee must be within the sender's token balance and the token must allow spending
     *   from the sender's account (sufficient allowance or no allowance needed).
     *
     * Note: The function first validates the permit signature using the permit function from IERC20Permit.
     * Then, it transfers the main amount to the receiver and the fee amount to the msg.sender (submitter).
     */
    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        // Permit signature
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // Permit
        IERC20Permit(token).permit(
            sender, address(this), amount + fee, deadline, v, r, s
        );
        // Send amount to receiver
        IERC20Permit(token).transferFrom(sender, receiver, amount);
        // Take fee - send fee to msg.sender
        IERC20Permit(token).transferFrom(sender, msg.sender, fee);
    }
}