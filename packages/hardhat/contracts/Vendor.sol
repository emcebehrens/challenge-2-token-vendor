pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountOfTokens = msg.value * tokensPerEth;
    console.log("calc tokens", amountOfTokens, msg.value);
    yourToken.transfer(msg.sender, amountOfTokens);

    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    console.log("function withdraw", msg.sender );

    uint256 ownerBalance = address(this).balance;
    require(ownerBalance > 0, "Owner has not balance to withdraw");
  
    // This function is not recommended for sending Ether.
    // bool sent = msg.sender .send();
    // require(sent, "Failed to send Ether");

    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send user balance back to the owner");
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount) public {
    // Check that the requested amount of tokens to sell is more than 0
    require(amount > 0, "Specify an amount of token greater than zero");

    // Check that the user's token balance is enough to do the swap
    // uint256 userBalance = yourToken.balanceOf(msg.sender);
    // require(userBalance >= tokenAmountToSell, "Your balance is lower than the amount of tokens you want to sell");

    // Check that the Vendor's balance is enough to do the swap
    uint256 amountOfETHToTransfer = amount / tokensPerEth;
    uint256 ownerETHBalance = address(this).balance;
    require(ownerETHBalance >= amountOfETHToTransfer, "Vendor has not enough funds to accept the sell request");

    (bool sent) = yourToken.transferFrom(msg.sender, address(this), amount);
    require(sent, "Failed to transfer tokens from user to vendor");

    (sent,) = msg.sender.call{value: amountOfETHToTransfer}("");
    require(sent, "Failed to send ETH to the user");

  }

}
