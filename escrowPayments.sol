// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

// 1) Make contract
// 2) Make struct item & Push items in array

// Escrow: Buyer sends money to contract. Seller send item to buyer. If the item is not right, the third party will be involved.
// If third party gives decision in favor of buyer, money will be returned.

// When item being inserted, only insert price and title. Status & Address given by self.
// Insert Item

// Buy Function: Buyer, want this item. Loop to check if item present in list. If yes, check if money_sent = item.value.
// convert eth to wei

contract EscrowPayments {


address public owner; // Part I
address public buyer;

Item[] items; // Part II
address public TTP; // Part V


struct Item {
 string name;
 uint price;
 bytes1 status;  // By default 'A'
 address buyer; // By default 0x0000000
}

// Part I
constructor() {
 owner = msg.sender;
}


modifier onlyBuyer() {
       require(msg.sender == buyer); // "Only buyer can call this method"
       _;
   }

modifier onlyOwner() {
       require(msg.sender == owner); // "Only owner can call this method"
        _;
      }

modifier onlyTTP() {
        require(msg.sender == TTP); // "Only TTP can call this method"
         _;
      }


function addItem(string memory itemName, uint price) public { // Part II

   Item memory ibcItem = Item (itemName, price,'A', payable(0));

   items.push(ibcItem);

}


function listItems() public view returns (Item[] memory) {  // Part III
 return items;
}


function addTTP(address ttpAddress) public { // Part V

  require(TTP == 0x0000000000000000000000000000000000000000); // Can only be called once
  require(msg.sender == owner); // Only owner can call
  TTP = ttpAddress;
}



function buyItem(string memory title) public payable {   // Part VI

//  FOR SEARCHING BY TITLE

uint index = 0;

for (uint i = 0; i < items.length; i++) {

        if ( keccak256(bytes(items[i].name)) == keccak256(bytes(title)) )
        index = i;
    }


  if (msg.value >= items[index].price) {

    items[index].buyer = msg.sender;
    items[index].status = 'P';
  }



  // If item received by buyer, transfer the eth in the contract to the owner

}



// PART VII
function confirmPurchase(string memory title, bool success) onlyBuyer public {  // Only person who purchased item can call this
// iteration

uint index = 0;

for (uint i = 0; i < items.length; i++) {

        if ( keccak256(bytes(items[i].name)) == keccak256(bytes(title)) )
        index = i;
    }

  if (success == true) {
     items[index].status = 'C';
}

  if (success == false) {
     items[index].status = 'D';
}

}


function handleDispute(string memory title, bytes1 newStatus) onlyTTP  public {

uint index = 0;

for (uint i = 0; i < items.length; i++) {

        if ( keccak256(bytes(items[i].name)) == keccak256(bytes(title)) )
        index = i;
    }

  items[index].status = newStatus;
}

/*
function receivePayment(string memory title) onlyBuyer onlyOwner public {  // Part IX

   if (items[0].status == 'C')
    owner.transfer(address(this).balance);  // If transaction confirmed send to owner

    if (items[0].status == 'R')
    buyer.transfer(address(this).balance);  // If transaction confirmed send to buyer

    items[0].status == 'E';

}

*/


}
