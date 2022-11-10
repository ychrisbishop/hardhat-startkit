import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from 'dotenv'

dotenv.config()

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      // url: process.env.HARDHAT_ALCHEMY_API_URL,
      url: 'https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
      accounts: [process.env.HARDHAT_PRIVATE_KEY || '']
    },
    hardhat: {
      
    }
  },
  mocha: {
    timeout: 100000000
  },
};

export default config;
