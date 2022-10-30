import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from 'dotenv'

dotenv.config()

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: process.env.HARDHAT_ALCHEMY_API_URL,
      accounts: [process.env.HARDHAT_PRIVATE_KEY || '']
    }
  }
};

export default config;
