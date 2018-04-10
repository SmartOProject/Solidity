pragma solidity ^0.4.18;

import "./interfaces/IERC20.sol";
import "./helpers/Ownable.sol";
import "./helpers/SafeMath.sol";

contract SmartOToken is Ownable, IERC20 {

  using SafeMath for uint256;

  /* Public variables of the token */
  string public constant name = "STO";
  string public constant symbol = "STO";
  uint public constant decimals = 18;
  uint256 public constant initialSupply = 12000000000 * 1 ether;
  uint256 public totalSupply;

  /* This creates an array with all balances */
  mapping (address => uint256) public balances;
  mapping (address => mapping (address => uint256)) public allowed;

  /* Events */
  event Burn(address indexed burner, uint256 value);
  event Mint(address indexed to, uint256 amount);

  /* Constuctor: Initializes contract with initial supply tokens to the creator of the contract */
  function SmartOToken() public {
      balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
      totalSupply = initialSupply;                        // Update total supply
  }


  /* Implementation of ERC20Interface */

  function totalSupply() public constant returns (uint256) { return totalSupply; }

  function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }

  /* Internal transfer, only can be called by this contract */
  function _transfer(address _from, address _to, uint _amount) internal {
      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
      require (balances[_from] >= _amount);                // Check if the sender has enough
      balances[_from] = balances[_from].sub(_amount);
      balances[_to] = balances[_to].add(_amount);
      Transfer(_from, _to, _amount);

  }

  function transfer(address _to, uint256 _amount) public returns (bool) {
    _transfer(msg.sender, _to, _amount);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require (_value <= allowed[_from][msg.sender]);     // Check allowance
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    _transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _amount) public returns (bool) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  function allowance(address _owner, address _spender) public constant returns (uint256) {
    return allowed[_owner][_spender];
  }

}