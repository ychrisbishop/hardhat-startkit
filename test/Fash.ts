import { ethers } from 'hardhat'
import { expect, assert, should, util } from 'chai'
import { BigNumber } from 'ethers'

describe('FLASH LOAN TEST', function () {

    let UniswapV3FlashTest: any
    let uniswapV3FlashTest: any

    const ONE_GWEI = 1_000_000_000;

    async function deploy () {
        UniswapV3FlashTest = await ethers.getContractFactory("UniswapV3FlashTest")
        uniswapV3FlashTest = await UniswapV3FlashTest.deploy()

        uniswapV3FlashTest.deployed()
    }
    const log = (...args:unknown[])=>{
        setTimeout(()=>{
            let indent = "\t";
            args = args.map(a=>util.inspect(a, true, 100, true).replace(/^\x1B\[32m['"`]/ig, '\x1B[32m').replace(/['"`]\x1B\[39m$/ig, '\x1B[39m').replace(/\n/g, `\n${indent} `))
            // args = args.map(a=>util.inspect(a))
            console.log.call(console, indent, ...args);
        })
    }
    beforeEach(async () => {
        await deploy()
    })
    // util
    describe('deploy and test flash loan sample function', async function () {

        it('contract address', async () => {
            
            const testValue = await uniswapV3FlashTest.test()

            log('test value', testValue)

            uniswapV3FlashTest.deposit({value: BigNumber.from(1000 * ONE_GWEI)});

            // const filter = {
            //     address: uniswapV3FlashTest,
            //     topics: [
            //         ethers.utils.id("Flash(uint, uint)")
            //     ]
            // }
            // const abi = ["Flash(uint, uint)"]
            // // flashTestContract.on(filter, (allowance: any, fee: any, event: any) => {
            // //     log('< flash event >', allowance, fee, event)
            // // })
            // // flashTestContract.on('Flash', (allowance: any, fee: any, event: any) => {
            // //     log('< flash event >', allowance, fee, event)
            // // })
            // let iface = new ethers.utils.Interface(abi)

            // log(uniswapV3FlashTest.address)
            // // const amount = BigNumber.from(2e15);
            // // log('send weth', amount)

            // // const tx = await uniswapV3FlashTest.testFlash({ value: amount })
            // const tx = await uniswapV3FlashTest.testFlash()
            // // console.log(tx)
            // const txResult = await tx.wait()
            // const logs = txResult.logs
            // console.log(txResult)
            // // log(logs[0])
            // logs.map((item: any) => {
            //     iface.parseLog(item).args.map((arg: any) => {
            //         log(arg)
            //     })
            // })
        })
    })
    
})
