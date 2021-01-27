// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract DStorage {
    string public name = "DStorage";
    uint256 public fileCount = 0;
    mapping(uint256 => File) public files;

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

    constructor() {}

    /*
     * @dev: Make sure file hash exists: 32 octets & base58
     */
    modifier verifiesHash(string memory _fileHash) {
        // TODO: Move string operation to StringUtils contract
        string memory startsWith = new string(2);
        bytes memory bytesStartsWith = bytes(startsWith);
        bytes memory byteHash = bytes(_fileHash);
        bytesStartsWith[0] = byteHash[0];
        bytesStartsWith[1] = byteHash[1];

        //Make sure file hash exists: starts with Qm + 32 octets
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
        files[fileCount] = File(
            fileCount,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _fileDescription,
            block.timestamp,
            payable(msg.sender)
        );

        fileCount++;
    }
}
