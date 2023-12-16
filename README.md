# WallToken
## Description 
WallToken is a simple ERC-20 Token implementation according to the eip-20. It implements all standard functionality.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Anvil

```shell
$ anvil
```

### Deploy
NYI

## TO-DO
1. ~~ERC-20 implementation~~
2. ~~Deploy script~~
    1. makefile
3. Tests

### Test Coverage

| File                         | % Lines         | % Statements   | % Branches     | % Funcs       |
|------------------------------|-----------------|----------------|----------------|---------------|
| script/DeployHelper.s.sol    | 0.00% (0/1)     | 0.00% (0/1)    | 100.00% (0/0)  | 0.00% (0/1)   |
| script/DeployWallToken.s.sol | 0.00% (0/6)     | 0.00% (0/7)    | 100.00% (0/0)  | 0.00% (0/1)   |
| src/WallToken.sol            | 100.00% (24/24) | 96.97% (32/33) | 91.67% (11/12) | 100.00% (9/9) |
| Total                        | 77.42% (24/31)  | 78.05% (32/41) | 91.67% (11/12) | 81.82% (9/11) |
