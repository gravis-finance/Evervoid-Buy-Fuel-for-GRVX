//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/IBurnableERC20.sol";
import "./interfaces/IMintableToken.sol";

contract FuelToGRVX is Ownable {
    using SafeERC20 for IBurnableERC20;

    address private grvxOutlet;    
    bool public burnStatus = false;
    uint256 private constant DAY = 1 days;
    uint256 public lastBlock;

    IBurnableERC20 grvx;
    IMintableToken fuel;

    mapping(address=>User) public addressToUser;

    struct User {
        uint256 lastBurn;
        uint256 boughtThisPeriod;
    }
    
    //EVENTS
    
    event grvxBurnt(
      address indexed burner,
      uint256 grvxBurnt,
      uint256 fuelMinted
    );

    // CONSTRUCTOR

    constructor(IBurnableERC20 grvx_, IMintableToken fuel_, address grvxOutlet_) Ownable() {
        grvx = grvx_;
        fuel = fuel_;
        grvxOutlet = grvxOutlet_;
        lastBlock = block.timestamp-(block.timestamp%86400);
    }

    // PUBLIC FUNCTIONS

    modifier updateLastBlock(){
        while(lastBlock+DAY<=block.timestamp){
            lastBlock+=DAY;
        }
        _;
    }

    function burnGRVX(uint256 amount) external updateLastBlock {
        require(burnStatus == true, "Contract not active at the moment");
        User storage user = addressToUser[msg.sender];
        if(block.timestamp - user.lastBurn>=DAY){
            user.boughtThisPeriod=0;
            user.lastBurn=lastBlock;
        }
        user.boughtThisPeriod+=amount;
        uint256 rate;
        if(user.boughtThisPeriod<31){
            rate=500;
        }else if(user.boughtThisPeriod<76){
            rate=600;
        }else if(user.boughtThisPeriod<151){
            rate=700;
        }else if(user.boughtThisPeriod<301){
            rate=800;
        }else{
            rate=1000;
        }
        uint256 amountToBurnt = amount * 10**18 * rate;
        uint256 fuelToMint = amount * 10**18;
        grvx.safeTransferFrom(msg.sender, grvxOutlet, amountToBurnt);
        fuel.mint(msg.sender, fuelToMint);
        emit grvxBurnt(msg.sender, amountToBurnt, fuelToMint);
    }

    //RESTRICTED FUNCTIONS
    
    function changeStatus(bool status) public onlyOwner {
        burnStatus = status;
    }

}
