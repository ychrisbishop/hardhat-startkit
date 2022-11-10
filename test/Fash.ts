import { ethers } from 'hardhat'
import { expect, assert, should, util } from 'chai'
import { BigNumber } from 'ethers'

describe('FLASH LOAN TEST', function () {

    let FlashTest: any
    let flashTestContract: any

    const ONE_GWEI = 1_000_000_000;

    async function deploy () {
        FlashTest = await ethers.getContractFactory("UniswapV3FlashTest")
        flashTestContract = await FlashTest.deploy()

        flashTestContract.deployed()
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
        // await deploy()
    })
    // util
    describe('deploy and test flash loan sample function', async function () {
        it('test feature', async () => {
            // ethers.utils.
            const amount = BigNumber.from('1')
            console.log(amount)
            // log(amount)
        })
        xit('contract address', async () => {
            
            const testValue = await flashTestContract.test()

            log('test value', testValue)

            const filter = {
                address: flashTestContract,
                topics: [
                    ethers.utils.id("Flash(uint, uint)")
                ]
            }
            const abi = ["event Flash(uint, uint)"]
            // flashTestContract.on(filter, (allowance: any, fee: any, event: any) => {
            //     log('< flash event >', allowance, fee, event)
            // })
            // flashTestContract.on('Flash', (allowance: any, fee: any, event: any) => {
            //     log('< flash event >', allowance, fee, event)
            // })
            let iface = new ethers.utils.Interface(abi)

            log(flashTestContract.address)
            const amount = BigNumber.from(2e15);
            log('send weth', amount)

            const tx = await flashTestContract.testFlash({ value: amount })
            log(tx)
            const logs = (await tx.wait()).logs
            // log(logs[0])
            logs.map((item: any) => {
                iface.parseLog(item).args.map((arg: any) => {
                    log(arg)
                })
            })

        })
    })
    
})
