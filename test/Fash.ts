import { ethers } from 'hardhat'

describe('flash loan', function () {

    async function deploy () {

    }
    describe('deploy', function () {
        it('test flash loan function', async () => {
            const FlashTest = await ethers.getContractFactory("UniswapV3FlashTest")
            const flashTest = await FlashTest.deploy()

            flashTest.deployed()

            console.log('flash test contract address: ', flashTest.address)

            const fee = await flashTest.testFlash()
            console.log('fee is : ', fee)
        })
    })
})
