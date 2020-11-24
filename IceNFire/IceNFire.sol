pragma solidity ^0.7;

// references: https://en.bitcoinwiki.org/wiki/ERC20
//              https://ethereum.org/en/developers/tutorials/transfers-and-approval-of-erc-20-tokens-from-a-solidity-smart-contract/
import "ERC20Interface.sol";

contract IceNFire is ERC20Interface{
        
    using SafeMath for uint256;
    
    // 3-letter token name of your choice
    string public constant symbol = "MAN";
    string public constant name = "Mandeep";
    
    // Probably the easiest way to track this information is in a 
    // mapping(address => bool) field of the contract. Be sure that it is private.
    mapping(address => bool) private freezeAccounts;             
    
    mapping(address => uint256) public balances;        // keep track of balances 
    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 supply = 10 ether;
    
    // contract creater
    address creator;

    constructor() {
        creator = msg.sender;
        balances[creator] = supply;
    }
    
    // Add a `burn(uint)` function. It should destroy the specified number of tokens, if the caller has sufficient tokens.
   function burn(uint tokens) public {
        require(tokens <= balances[msg.sender], "Caller does not have sufficient tokens");
        
        balances[msg.sender] = balanceOf(msg.sender).sub(tokens);
        supply = totalSupply().sub(tokens);
    }
    
    
    // freeze(address) -- Marks the given address as frozen.
    // Give the contract creator special power to freeze accounts, making the tokens unspendable.
    function freeze(address account) public {
        require(creator == msg.sender, "Only the creator has authorization to freeze accounts");
        freezeAccounts[account] = true; 
    }

    // thaw(address) -- Unmarks the given address as frozen.
    function thaw(address account) public {
         require(creator == msg.sender, "Only the creator has authorization to thaw accounts");
         freezeAccounts[account] = false; 
    }
    
    function transfer(address to, uint tokens) public virtual override returns (bool success){
        
        // fail to transfer funds if the sender's account is frozen.
        require(freezeAccounts[msg.sender] == false, "The senders account is frozen");
        
        // check if the sender has valid funds 
        require(balances[msg.sender] >= tokens, "Sender has invalid funds");
        
       balances[msg.sender] = balances[msg.sender].sub(tokens);
       balances[to] = balances[to].add(tokens);
        
       emit Transfer(msg.sender, to, tokens);
       return true;
        
    }
    
    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success) {
        // to-do 
        require(balances[from] >= tokens, "The sender does not have enough funds");
        require(freezeAccounts[from] == false, "The senders account is frozen");
        require(tokens <= allowed[from][msg.sender]);
        
        balances[from] = balances[from].sub(tokens);
      //  balances[from] = sub(balances[from],tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        
        emit Transfer(from, to, tokens);
        return true;
    }
    
    function totalSupply() public virtual view override returns (uint) {
          
        return supply;
    }

    function balanceOf(address tokenOwner) public virtual view override returns (uint balance) {
          
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public virtual view override returns (uint remaining){
         
        return allowed[tokenOwner][spender];
    }
    
    function approve(address spender, uint tokens) public virtual override returns (bool success) {
        //to-do
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}




