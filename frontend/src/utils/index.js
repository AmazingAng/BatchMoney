import { ethers } from "ethers";
import { supportedChains } from "./constants";

export const isValidAddress = (address) => ethers.utils.isAddress(address);

export const isValidValue = (value) => {
  try {
    return ethers.utils.parseUnits(value, "ether");
  } catch (err) {
    return false;
  }
};

export const isChainSupported = (chainId) =>
  supportedChains.some((chain) => chain.chainId === chainId);

export const getNetworkInfo = (chainId) =>
  supportedChains.find((chain) => chain.chainId === chainId);

export const getWarnMessage = () => {
  let networks = ``;
  supportedChains.map((chain, i) => {
    if (i === 0) {
      networks += `${chain.name}`;
    } else if (i === supportedChains.length - 1) {
      networks += ` and ${chain.name}`;
    } else {
      networks += `, ${chain.name}`;
    }
  });
  return `*Supports ${networks}*`;
};

export const parseText = (textValue) => {
  const lines = textValue.split("\n");
  let updatedRecipients = [];

  lines.map((line) => {
    if (
      line.includes(" ") ||
      line.includes(",") ||
      line.includes("=") ||
      line.includes("\t")
    ) {
      const [address, value] = line.split(/[,= \t]+/);
      const validValue = isValidValue(value);
      if (isValidAddress(address) && validValue) {
        updatedRecipients.push({
          address,
          value: validValue,
        });
      }
    }
  });

  return updatedRecipients;
};
