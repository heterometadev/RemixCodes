// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts@4.8.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.8.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts@4.8.1/access/Ownable.sol";

contract DimenziaBuyTest is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable,
    ReentrancyGuard
{

    //attributes
    // Standart for ERC721
    bool public publicSaleActive;
    uint256 public publicSaleStartTime;
    uint256 public phaseIndex;
    uint256 public tokenId = 1;

    //Mapping for holding which address mint how much dimenzia ?
    mapping(address => uint256) public mintedPerAddress;

    // constants
    uint256 public constant phase1 = 59;
    uint256 public constant phase2 = 145;
    uint256 public constant phase3 = 72;
    uint256 public constant phase4 = 517;
    uint256 public constant phase5 = 558;
    uint256 public constant phase6 = 1452;
    uint256 public constant phase7 = 1642;
    uint256 public constant phase8 = 4621;
    uint256 public constant phase9 = 1618;
    uint256 public constant phase10 = 1352;
    uint256 public constant phase11 = 4311;
    uint256 public constant phase12 = 1653;

    uint256 public constant MAX_NFT = 18000;

    // modifiers
    modifier whenPublicSaleActive() {
        require(publicSaleActive, "Public sale is not active");
        _;
    }

    // events
    event NFTPublicSaleStart(uint256 indexed _saleStartTime);

    event NFTPublicSaleStop(uint256 indexed _timeElapsed);

    function getElapsedSaleTime() private view returns (uint256) {
        return
            publicSaleStartTime > 0 ? block.timestamp - publicSaleStartTime : 0;
    }

    function startPublicSale() external onlyOwner {
        publicSaleStartTime = block.timestamp;
        emit NFTPublicSaleStart(publicSaleStartTime);
        publicSaleActive = true;
    }

    function stopPublicSale() external onlyOwner whenPublicSaleActive {
        emit NFTPublicSaleStop(getElapsedSaleTime());
        publicSaleActive = false;
    }

    function setPhaseIndex(uint256 phase) external onlyOwner {
        phaseIndex = phase;
    }

    constructor() ERC721("DimenziaBuyTest", "DMNZ") {}

    function stringToUint(string memory s) public pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
        return result;
    }

    function setTokenIdAccordingToPhaseIndex(uint256 _phaseIndex) public onlyOwner{
        if (_phaseIndex == 1) {
            tokenId = 1;
        } else if (_phaseIndex == 2) {
            tokenId = 60;
        } else if (_phaseIndex == 3) {
            tokenId = 205;
        } else if (_phaseIndex == 4) {
            tokenId = 277;
        } else if (_phaseIndex == 5) {
           tokenId = 794;
        } else if (_phaseIndex == 6) {
            tokenId = 1352;
        } else if (_phaseIndex == 7) {
           tokenId = 2804;
        } else if (_phaseIndex == 8) {
           tokenId = 4446;
        } else if (_phaseIndex == 9) {
            tokenId = 9067;
        } else if (_phaseIndex == 10) {
           tokenId = 10685;
        } else if (_phaseIndex == 11) {
           tokenId = 1237;
        } else if (_phaseIndex == 12) {
            tokenId = 16348;
        } else {
            revert();
        }
    }

    function mintDimenzia(address to, string memory uri)
        public
        payable
        whenPublicSaleActive
        nonReentrant
    {
        uint256 mintPrice = 0.00015 ether;
        uint256 dimenziaMaxSaleCount;

        if (phaseIndex == 1) {
            dimenziaMaxSaleCount = phase1;
            mintPrice = 0.00015 ether;
        } else if (phaseIndex == 2) {
            dimenziaMaxSaleCount = phase2;
            mintPrice = 0.00014 ether;
        } else if (phaseIndex == 3) {
            dimenziaMaxSaleCount = phase3;
            mintPrice = 0.00013 ether;
        } else if (phaseIndex == 4) {
            dimenziaMaxSaleCount = phase5;
            mintPrice = 0.00012 ether;
        } else if (phaseIndex == 5) {
            dimenziaMaxSaleCount = phase5;
            mintPrice = 0.00011 ether;
        } else if (phaseIndex == 6) {
            dimenziaMaxSaleCount = phase6;
            mintPrice = 0.00010 ether;
        } else if (phaseIndex == 7) {
            dimenziaMaxSaleCount = phase7;
            mintPrice = 0.00009 ether;
        } else if (phaseIndex == 8) {
            dimenziaMaxSaleCount = phase8;
            mintPrice = 0.00008 ether;
        } else if (phaseIndex == 9) {
            dimenziaMaxSaleCount = phase9;
            mintPrice = 0.00007 ether;
        } else if (phaseIndex == 10) {
            dimenziaMaxSaleCount = phase11;
            mintPrice = 0.00006 ether;
        } else if (phaseIndex == 11) {
            dimenziaMaxSaleCount = phase11;
            mintPrice = 0.00005 ether;
        } else if (phaseIndex == 12) {
            dimenziaMaxSaleCount = phase12;
            mintPrice = 0.00004 ether;
        } else {
            revert();
        }

        uint256 mintIndex = totalSupply();
        require(
            tokenId <= dimenziaMaxSaleCount,
            "Current Phase of Dimenzias are already sold"
        );
        require(mintIndex < MAX_NFT, " All Dimenzias are already sold");
        require(mintPrice <= msg.value, " Ether value sent is not correct");
        //Check for minted addres has more than max mint per address
        mintedPerAddress[msg.sender] += 1;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        tokenId++;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 _tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, _tokenId, batchSize);
    }

    function _burn(uint256 _tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(_tokenId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(_tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
