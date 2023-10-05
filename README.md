# Batch.Money

Efficiently transfer ether or tokens to many addresses in batch, powered by [Huff](https://github.com/huff-language/huff-rs) and [WTF Academy](https://wtf.academy).

## Key Features

1. Efficiently transfer ether or tokens in batch. Saves 2~3% gas compared to Disperse App.

2. Support non-standard ERC20 (i.e. [USDT](https://etherscan.io/address/0xdac17f958d2ee523a2206206994597c13d831ec7#code)).

## Test: Transfer ERC20 to 100 addresses on Goerli

To test the gas consumption fairly, we created a new tokens for different methods. For normal transfer, we record the gas used by transfering token to 1 address, and then multiply it by 100.

| type    | gas consumption | txn proof| 
| -------- | -------- | -------- | 
| Normal Transfer  | 5,212,400 | [link](https://goerli.etherscan.io/tx/0x35549e3c4e4f2116515b3f4a2496ff8d2c455d2cc1a2fce3b97b193ef838e3cd) single txn      |
| Disperse  | 2,754,920 | [link](https://goerli.etherscan.io/tx/0x9d20b73d7b102aacc63dadf01ed7767cbbfd1c3f92302b08f6741be4bd8fb6cf)      |
| BatchMoney  | 2,694,098 ✅ | [link](https://goerli.etherscan.io/tx/0xdfd94600c57f72dc54e8741c084ab2e5544556e76baa0d6413b5189a6872f35a)      |

## Quick Start

1. Clone this repo or use template

```shell
git clone https://github.com/AmazingAng/BatchMoney
cd BatchMoney
```

2. Install dependencies

```shell
forge install
```

3. Build & Test

```shell
forge build
forge test
```

## Reference

1. [disperse research](https://github.com/banteg/disperse-research)
2. [disperse clone](https://github.com/rajkharvar/disperse-clone)
3. [huffmate](https://github.com/huff-language/huffmate)
4. [TxRouter](https://github.com/wangshouh/TxRouter)
