import { useState, useEffect, useContext } from "react";
import { ethers } from "ethers";

import BatchTransfer from "../artifacts/BatchTransfer.json";
import { getNetworkInfo, parseText } from "../utils/index";
import Recipients from "./Recipients";
import ConfirmEther from "./ConfirmEther";
import { NetworkContext } from "../App";

const Ether = ({ address }) => {
  const [ethBalance, setEthBalance] = useState(null);
  const [textValue, setTextValue] = useState("");
  const [total, setTotal] = useState(null);
  const [recipientsData, setRecipientsData] = useState([]);
  const [remaining, setRemaining] = useState(null);
  const { chainId } = useContext(NetworkContext);
  const [txStatus, setTxStatus] = useState(null);
  const networkInfo = getNetworkInfo(chainId);
  const batchTransferAddress = networkInfo?.batchTransferAddress;

  const getEthBalance = async () => {
    const { ethereum } = window;
    if (!ethBalance) {
      const provider = new ethers.providers.Web3Provider(ethereum);
      let ethBalance = await provider.getBalance(address);
      ethBalance = ethers.utils.formatEther(ethBalance);
      setEthBalance(ethBalance);
    }
  };

  useEffect(() => {
    getEthBalance();
  }, []);

  useEffect(() => {
    setRecipientsData(parseText(textValue));
  }, [textValue]);

  useEffect(() => {
    if (recipientsData.length > 0) {
      let newTotal = recipientsData[0].value;
      for (let i = 1; i < recipientsData.length; i++) {
        newTotal = newTotal.add(recipientsData[i].value);
      }
      setTotal(newTotal);
    } else {
      setTotal(null);
    }
  }, [recipientsData]);

  const batchTransferETH = async () => {
    try {
      setTxStatus(null);
      const { ethereum } = window;
      if (ethereum && batchTransferAddress) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const batchTransferContract = new ethers.Contract(
          batchTransferAddress,
          BatchTransfer.abi,
          signer
        );

        const recipients = recipientsData.map((recipient) => recipient.address);
        const values = recipientsData.map((recipient) => recipient.value);

        console.log("Batch Transfer ETH now");
        console.log(total);
        const txn = await batchTransferContract.batchTransferETH(recipients, values, {
          value: total,
        });
        setTxStatus({
          hash: txn.hash,
          status: "pending",
        });
        await txn.wait();
        setTxStatus({
          hash: txn.hash,
          status: "success",
        });
        console.log("Completed Batch Transfer ETH");
      }
    } catch (error) {
      console.log("error occured while batch transfer ETH");
      console.log(error);
    }
  };

  useEffect(() => {
    if (ethBalance && total) {
      const tokenBalance = ethers.utils.parseEther(ethBalance);
      const remaining = tokenBalance.sub(total);
      setRemaining(ethers.utils.formatEther(remaining));
    } else {
      setRemaining(null);
    }
  }, [total]);

  return (
    <p className="pt-4 text-l font-light italic">
      you have {ethBalance} <span className="pt-1 text-sm">ETH</span>
      <Recipients
        textValue={textValue}
        setTextValue={setTextValue}
        tokenSymbol={"ETH"}
      />
      {recipientsData.length > 0 && (
        <ConfirmEther
          recipientsData={recipientsData}
          total={total}
          batchTransfer={batchTransferETH}
          tokenBalance={ethBalance}
          remaining={remaining}
          txStatus={txStatus}
        />
      )}
    </p>
  );
};

export default Ether;
