export const initState = {
  chainId: null,
  network: null,
};

export const reducer = (state, action) => {
  switch (action.type) {
    case "SET_CHAIN_ID": {
      return {
        ...state,
        chainId: action.payload,
      };
    }
    case "SET_NETWORK": {
      return {
        ...state,
        network: action.payload,
      };
    }
    default:
      return state;
  }
};
