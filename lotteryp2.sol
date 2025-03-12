// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract lottery {
    address public MANAGER;
    address payable [] public participants;

    constructor()  {
        MANAGER = msg.sender;
    }

    receive() external payable {
        require(msg.value == 2 ether , "not enough payment");
         require(msg.sender != MANAGER, "Manager cannot participate");
        participants.push(payable (msg.sender));
         
     }

     // Function to see the contract balance
     function GETBALANCE()public view returns (uint) {
        require(msg.sender==MANAGER, "Only manager can check balance");
        return address(this).balance;
     }
     function rendom()public view returns (uint) { 
       return  uint(keccak256(abi.encodePacked(block.prevrandao , block.timestamp , participants.length)));
     }
     function selectWINNER()public {
        require(msg.sender==MANAGER, "Only manager can select winner");
        require(participants.length >=3, "Not enough participants");


        uint r = rendom();
        address payable winner;

        uint index = r % participants.length;
        winner = participants[index];

        // Transfer the entire balance to the winner
        winner.transfer(GETBALANCE());
        MANAGER=address (0);

        // Ensure balance is zero
        participants=new address payable[] (0);

        // Reset lottery for next round
        delete participants;
     }
}

 

