//import DStorage from '../abis/DStorage.json'
import { Component } from "react";
import "./App.css";

const ipfsClient = require("ipfs-http-client");
const ipfs = ipfsClient({
  host: "ipfs.infura.io",
  port: 5001,
  protocol: "https",
}); // leaving out the arguments will default to these values

class App extends Component {
  // Get file from user: convert files into a Buffer
  captureFile = (event) => {
    event.preventDefault();

    const file = event.target.files[0];
    const reader = new window.FileReader();

    reader.readAsArrayBuffer(file);
    reader.onloadend = () => {
      this.setState({
        buffer: Buffer(reader.result),
        type: file.type,
        name: file.name,
      });
      console.log("buffer", this.state.buffer);
    };
  };

  uploadFile = (description) => {
    console.log("Submitting file to IPFS...");

    // Add file to the IPFS
    ipfs.add(this.state.buffer, (error, result) => {
      result.hash, // hash to retrieve uploaded file
        result.size; // size of uploaded file
    });
  };
}

export default App;
