// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract StringUtils {
    function getCharsAt(
        string memory _string,
        uint256 from,
        uint256 to
    ) public pure returns (string memory) {
        uint256 length = (to - from) + 1;

        string memory startsWith = new string(length);
        bytes memory bytesStartsWith = bytes(startsWith);
        bytes memory byteHash = bytes(_string);

        for (uint256 i = from; i < to + 1; i++) {
            bytesStartsWith[i] = byteHash[i];
        }

        return string(bytesStartsWith);
    }
}
