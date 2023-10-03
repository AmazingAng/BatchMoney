const WalletInfo = ({ address, provider }) => {
  return (
    <div className="pt-16">
      <h3 className="text-2xl font-light italic">connect to wallet</h3>
      <p className="pt-3 text-l font-light">logged in as {address}</p>
    </div>
  );
};

export default WalletInfo;
