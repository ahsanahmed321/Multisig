// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract MultiSig {
    mapping(address => bool) public isOwner;
    address[] public owners;
    uint256 public approvalsRequired;
    Transaction[] public transactions;

    struct Transaction {
        address to;
        uint256 amount;
        bytes data;
        uint256 approvals;
        bool executed;
    }

    modifier OwnersOnly() {
        require(isOwner[msg.sender]);
        _;
    }

    constructor(address[] memory _owners, uint256 _approvalsRequired) {
        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "invalid address");
            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }
        approvalsRequired = _approvalsRequired;
    }

    function createTransaction(
        address _to,
        bytes calldata data,
        uint256 _amount
    ) public OwnersOnly {
        transactions.push(
            Transaction({
                to: _to,
                data: data,
                amount: _amount,
                approvals: 0,
                executed: false
            })
        );
    }

    function executeTransaction(uint256 index) public OwnersOnly {
        Transaction storage transaction = transactions[index];
        (bool success, ) = transaction.to.call{value: transaction.amount}(
            transaction.data
        );
        require(success, "Tx Failed");
    }
}
