pragma solidity ^0.8.7;

// contracts/GameItems.sol
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract GameItems is ERC1155 {
    uint256 public constant CHARIZARD = 0;
    uint256 public constant VENUSAUR = 1;

    constructor() public ERC1155 ("http://localhost:8000/{id}.json"){

        _mint(msg.sender, CHARIZARD, 100, "");
        _mint(msg.sender, VENUSAUR, 100, "");
    }


}
