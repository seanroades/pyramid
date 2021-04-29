// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract pyramidToken {
    string public constant name = "Pyramid Coin";
    string public constant symbol = "TRI";
    uint8 public constant decimals = 18;

    uint256 public __totalSupply = 0;

    constructor(uint256 __initialSupply) public {
        __balanceOf[msg.sender] = __initialSupply;
        __level[msg.sender] = 0;
        __totalSupply = __initialSupply;
    }

    mapping(address => uint) private __balanceOf;
    mapping(address => address) private __referredBy;
    mapping(address => uint) private __level;
    mapping(address => bool) private __acceptedReferral;

    function totalSupply() public view returns (uint256 _totalSupply) {
        _totalSupply = __totalSupply;
    }

    function referedBy(address addr) public view returns (address referer) {
        return __referredBy[addr];
    }

    function balanceOf(address addr) public view returns (uint256 balance) {
        return __balanceOf[addr];
    }

    function levelOf(address addr) public view returns (uint256 level) {
        return __level[addr];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (_value > 0 && _value <= balanceOf(msg.sender)) {
            __balanceOf[msg.sender] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }

    function extendReferral(address _to) public returns (bool success) {
        // Require that the sender cannot refer themselves
        require(_to != msg.sender);

        // Extend referral
        __referredBy[_to] = msg.sender;
        return true;
    }

    // Payout the previous referrals

    function acceptReferral(address referer) public returns (bool success) {
        // Require that the person was refered and that the value is not the default value, address(0)
        require(__referredBy[msg.sender] == referer);

        __acceptedReferral[msg.sender] == true;

        // Set level of referee to 1 further down than the referer
        __level[msg.sender] = __level[__referredBy[msg.sender]] + 1;

        // Give joiner some triangles
        __balanceOf[msg.sender] += 5;
        __totalSupply += 5;

        address wallet = msg.sender;
        
        // Payout levels starting from bottom up to top working through who refered who
        for (uint i = 0; i < 17; i++) {
            if (__level[wallet] == 0 || i == 16) {
                return true;
            }
            else {
                __balanceOf[__referredBy[wallet]] += 5;
                __totalSupply += 5;
                wallet = __referredBy[wallet];
            }
        }
    }

    function claimTriangles() public returns (bool success) {
        __balanceOf[msg.sender] += 2;
        __totalSupply += 2;
        return true;
    }

}