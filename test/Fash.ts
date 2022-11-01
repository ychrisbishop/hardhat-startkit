import { ethers } from 'hardhat'

describe('flash loan test', function () {

    let FlashTest
    let flashTest

    async function deploy () {
        FlashTest = await ethers.getContractFactory("UniswapV3FlashTest")
    }
    describe('deploy and test flash loan sample function', function () {
        it('contract address', async () => {
            const FlashTest = await ethers.getContractFactory("UniswapV3FlashTest")
            const flashTest = await FlashTest.deploy()

            flashTest.deployed()

            console.log('flash test contract address: ', flashTest.address)

            const value = await flashTest.testFlash()
            console.log('fee is : ', value)
        })
    })
    
})
