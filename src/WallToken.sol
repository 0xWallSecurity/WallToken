// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

/*
A sample ERC20 Token following the eip-20
*/

/* IMPORTS */

contract WallToken {
    /* TYPE DECLARATIONS */

    /* STATE VARIABLES */
    string private i_name;
    string private i_symbol;
    uint8 private i_decimals;

    uint256 private s_totalSupply;

    mapping (address => uint256) private s_balances;
    mapping (address => mapping (address => uint256)) private s_allowances;

    /* EVENTS */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /* ERRORS */
    error WallToken__NotEnoughTokens();
    error WallToken__MissingApproval();
    error WallToken__CannotSendToZeroAddress();

    /* FUNCTIONS */

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        i_name = _name;
        i_symbol = _symbol;
        i_decimals = _decimals;
    }

    /**
     @dev this function throws, if the account does not have enough tokens to transfer
     @dev fires transfer event
     @param _to address to send tokens to
     @param _value amount of tokens to send
     @return success state of the transfer (success => True)
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        if (s_balances[msg.sender] < _value) revert WallToken__NotEnoughTokens();
        if (_to == address(0)) revert WallToken__CannotSendToZeroAddress();
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     @dev this function throws, if the _from address has not given explicit approval
     @dev fires transfer event
     @param _from address to send the tokens from
     @param _to address to send tokens to
     @param _value amount of tokens to send
     @return success state of the transfer (success => True)
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        if (s_allowances[_from][msg.sender] < _value) revert WallToken__MissingApproval();
        if (s_balances[_from] < _value) revert WallToken__NotEnoughTokens();
        if (_to == address(0)) revert WallToken__CannotSendToZeroAddress();
        s_balances[_from] -= _value;
        s_balances[_to] += _value;
        s_allowances[_from][msg.sender] -= _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     @notice approves the spender address to transfer from their account
     @dev emits the Approval event
     @param _spender address to approve spending tokens on their behalf
     @param _value the maximum value the spender is allowed to spend on their behalf
     @return success of approval
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        if (_spender == address(0)) revert WallToken__CannotSendToZeroAddress();
        s_allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     @notice returns the amount _spender is still allowed to spend on _owner|s behalf
     @param _owner owner of the tokens
     @param _spender approved spender the owners tokens
     @return remaining amount left to spend
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return s_allowances[_owner][_spender];
    }

    /**
     @return returns the name of the token
     */
    function name() public view returns (string memory) {
        return i_name;
    }

    /**
     @return returns the symbol of the token
     */
    function symbol() public view returns (string memory) {
        return i_symbol;
    }

    /**
     @return returns the number of decimals the token uses
     */
    function decimals() public view returns (uint8) {
        return i_decimals;
    }

    /**
     @return total token supply
     */
    function totalSupply() public view returns (uint256) {
        return s_totalSupply;
    }

    /**
     @param _owner address of the account to check the balance of
     @return balance of the account
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }
}