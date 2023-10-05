const Connect = ({ connect }) => {
  return (
    <div className="pt-16">
      <h3 className="text-2xl font-light italic">connect to wallet</h3>
      <button
        onClick={connect}
        className="px-2 mt-6 p-2 italic"
        style={{
          background: "aquamarine",
          boxShadow: "6px 6px crimson",
        }}
      >
        connect wallet
      </button>
      <p className="mt-6">please unlock metamask</p>
    </div>
  );
};

export default Connect;
