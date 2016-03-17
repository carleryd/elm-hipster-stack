const React = require('react');
const ReactDOM = require('react-dom');


const RelayTestUtils = {
  renderContainerIntoDocument(containerElement, relayOptions) {
    relayOptions = relayOptions || {};

    const relaySpec = {
      forceFetch: jest.genMockFn(),
      getPendingTransactions: jest.genMockFn().mockImplementation(() => relayOptions.pendingTransactions),
      hasOptimisticUpdate: jest.genMockFn().mockImplementation(() => relayOptions.hasOptimisticUpdate),
      route: relayOptions.route || { name: 'MockRoute', path: '/mock' },
      setVariables: jest.genMockFn(),
      variables: relayOptions.variables || {}
    };

    return ReactDOM.render(
      React.cloneElement(containerElement, { relay: relaySpec }),
      document.createElement('div')
    );
  },
};

export default RelayTestUtils;
