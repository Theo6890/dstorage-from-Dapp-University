// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./StringUtils.sol";

contract DStorage {
    string public name = "DStorage";
    uint256 public fileCount = 0;
    mapping(uint256 => File) public files;
    StringUtils sUtils;

    struct File {
        uint256 fileId;
        string fileHash;
        uint256 fileSize;
        string fileType;
        string fileName;
        string fileDescription;
        uint256 uploadTime;
        address payable uploader;
    }

    event FileUploaded(
        uint256 fileId,
        string fileHash,
        uint256 fileSize,
        string fileType,
        string fileName,
        string fileDescription,
        uint256 uploadTime,
        address payable uploader
    );

    constructor(StringUtils _sUtils) {
        sUtils = _sUtils;
    }

    /*
     * @dev: Make sure file hash exists: 32 octets & base58
     */
    modifier verifiesHash(string memory _fileHash) {
        string memory bytesStartsWith = sUtils.getCharsAt(_fileHash, 0, 1);

        require(
            bytes(_fileHash).length >= 32,
            "File hash not valid: 32 bytes required"
        );
        require(
            keccak256(abi.encodePacked(bytesStartsWith)) ==
                keccak256(abi.encodePacked("Qm")),
            "File hash not valid: base58 required"
        );
        _;
    }

    function uploadFile(
        string memory _fileHash,
        uint256 _fileSize,
        string memory _fileType,
        string memory _fileName,
        string memory _fileDescription
    ) public verifiesHash(_fileHash) {
        require(bytes(_fileType).length >= 0, "Type not specified");
        require(
            bytes(_fileDescription).length >= 0,
            "Description not specified"
        );
        require(bytes(_fileName).length >= 0, "Name type not specified");
        require(msg.sender != address(0));
        require(_fileSize >= 0);

        uint256 uploadTime = block.timestamp;
        address payable uploader = payable(msg.sender);

        files[fileCount] = File(
            fileCount,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _fileDescription,
            uploadTime,
            uploader
        );

        fileCount++;

        emit FileUploaded(
            fileCount - 1,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _fileDescription,
            uploadTime,
            uploader
        );
    }
}
