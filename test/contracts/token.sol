// https://github.com/nexusdev/erc20/blob/master/contracts/base.sol

pragma solidity ^0.4.7;
contract Token {

  event Transfer(address indexed from, address indexed to, uint value);
  event Approval( address indexed owner, address indexed spender, uint value);

  mapping( address => uint ) _balances;
  mapping( address => mapping( address => uint ) ) _approvals;
  uint _supply;
  function Token( uint initial_balance ) {
    _balances[msg.sender] = initial_balance;
    _supply = initial_balance;
  }
  function totalSupply() constant returns (uint supply) {
    return _supply;
  }
  function balanceOf( address who ) constant returns (uint value) {
    return _balances[who];
  }
  function transfer( address to, uint value) returns (bool ok) {
    if( _balances[msg.sender] < value ) {
      throw;
    }
    if( !safeToAdd(_balances[to], value) ) {
      throw;
    }
    _balances[msg.sender] -= value;
    _balances[to] += value;
    Transfer( msg.sender, to, value );
    return true;
  }
  function transferFrom( address from, address to, uint value) returns (bool ok) {
    // if you don't have enough balance, throw
    if( _balances[from] < value ) {
      throw;
    }
    // if you don't have approval, throw
    if( _approvals[from][msg.sender] < value ) {
      throw;
    }
    if( !safeToAdd(_balances[to], value) ) {
      throw;
    }
    // transfer and return true
    _approvals[from][msg.sender] -= value;
    _balances[from] -= value;
    _balances[to] += value;
    Transfer( from, to, value );
    return true;
  }
  function approve(address spender, uint value) returns (bool ok) {
    // TODO: should increase instead
    _approvals[msg.sender][spender] = value;
    Approval( msg.sender, spender, value );
    return true;
  }
  function allowance(address owner, address spender) constant returns (uint _allowance) {
    return _approvals[owner][spender];
  }
  function safeToAdd(uint a, uint b) internal returns (bool) {
    return (a + b >= a);
  }
}
