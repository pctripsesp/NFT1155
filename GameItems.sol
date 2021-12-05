// contracts/GameItems.sol
// SPDX-License-Identifier: MIT


pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";




contract NftTrader {


    mapping(address => mapping(uint256 => Listing)) public listings;
    mapping(address => uint256) public balances;

    //listing[<CONTRACT_ADDRESS>][<TOKEN_ID>]
    struct Listing{

        uint256 price;
        address seller;    

    }

    // to list on "market" our token
    function addListing (uint256 price, address contractAddr, uint256 tokenId) public {
        ERC1155 token = ERC1155 (contractAddr);
        // CHECK IF THE OWNER OF THE ADDRES HAS SOME TOKEN TO BE LISTED
        require(token.balanceOf(msg.sender, tokenId) > 0, "caller must own given token");
        // CHECK APPROVED CONTRACT, ALLOWING AUTOMATIZATION OF ALL; address(this) == address of the contract. 
        require(token.isApprovedForAll(msg.sender, address(this)), "contract must be approved");

        listings[contractAddr][tokenId] = Listing(price, msg.sender);

    }

    // amount is the number of NFTs you wanna buy
    function purchase (address contractAddr, uint256 tokenId, uint256 amount) public payable {

        Listing memory item = listings[contractAddr][tokenId];
        // CHECK IF ENOUGHT MONEY WAS SENT TO THE CONTRACT
        require(msg.value >= item.price * amount, "insufficient founds sent");
        // CHECK IF WE ARE INCREMENTING THE BALANCE OF THE SELLER
        balances[item.seller] += msg.value;

        // NOW USING ERC1155 IMPORTED FUNCTION, SEND THE TOKEN TO THE BUYER
        ERC1155 token = ERC1155(contractAddr);
        token.safeTransferFrom(item.seller, msg.sender, tokenId, amount, "");

    }

    // THIS ALLOWS THE SELLER TO RECEIVE THE MONEY
    function withdraw(uint256 amount, address payable destAddr) public {

        require(amount <= balances[msg.sender], "insufficient funds");
        balances[msg.sender] -= amount;
        destAddr.transfer(amount);



    }

}
