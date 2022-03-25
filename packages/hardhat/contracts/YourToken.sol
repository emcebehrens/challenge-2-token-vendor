pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
        _mint(msg.sender, 2000 * 10 ** 18);
        //_mint(msg.sender, initialSupply);

        console.log("YourToken constructor", msg.sender, totalSupply());
        console.log("\t", msg.sender, balanceOf(msg.sender));
    }

    // Can we override transfer() ??
    // 
    // function transfer(address to, uint256 amount) public override returns (bool) {
    //     console.log("YourToken transfer", msg.sender, to, amount);
    //     return ERC20.transfer(to, amount);
    // }
}
