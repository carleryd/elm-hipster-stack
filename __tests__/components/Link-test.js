jest.unmock('../../web/static/js/components/Link');

const TestUtils = require('react-addons-test-utils');
const React = require('react');
const Link = require('../../web/static/js/components/Link');

describe('the Link component', () => {
  describe('the search', () => {
    it('should display name of the link', () => {
      const node = {
        url: 'http://react.is.the.best.com',
        title: 'Why React?',
        createdAt: Date.now(),
      };

      const linkComponent = TestUtils.renderIntoDocument(
        <Link link={node} />
      );

      const label = TestUtils.findRenderedDOMComponentWithTag(linkComponent,'a');

      expect(lable.textContent).toEqual(link.title);
    });
  });
});
