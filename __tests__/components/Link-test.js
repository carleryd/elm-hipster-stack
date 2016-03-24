'use strict';

jest.unmock('../../web/static/js/components/Link');
jest.unmock('../../web/static/js/utils/RelayTestUtils');
jest.unmock('../../web/static/js/shared/urlPrettify');
import TestUtils from 'react-addons-test-utils';
import RelayTestUtils from '../../web/static/js/utils/RelayTestUtils';
import React from 'react';
import ReactDOM from 'react-dom';

import Link from '../../web/static/js/components/Link';

describe('the Link component', () => {
  it('should display name of the tile, url and date http', () => {
    const link = {
      url: 'http://react.is.the.best.com',
      title: 'Why React?',
      createdAt: 1458396953522,
    };

    const linkComponent = RelayTestUtils.renderContainerIntoDocument(
      <Link link={link} />
    );

    const labels = TestUtils
                   .scryRenderedDOMComponentsWithTag(linkComponent,'a');

    // Title
    expect(labels[0].textContent).toEqual(link.title);
    expect(labels[0].getAttribute('href')).toEqual(link.url);

    // URL
    expect(labels[1].textContent).not.toEqual(link.url);
    expect(labels[1].textContent).toEqual('react.is.the.best.com');
    expect(labels[1].getAttribute('href')).toEqual(link.url);
    // Date

    const date = TestUtils
                 .findRenderedDOMComponentWithTag(linkComponent,'span');

    expect(date.textContent).toEqual('03/19/2016');
  });

  it('should have optimistic update', () => {
    const link = {
      url: 'https://www.optimistic.com/',
      title: 'Facebook',
      createdAt: 1458300000000,
    };
    const linkComponent = RelayTestUtils.renderContainerIntoDocument(
      <Link link={link}/>,{
        hasOptimisticUpdate: true,
      }
    );
    // Date
    const date = TestUtils
                .findRenderedDOMComponentWithTag(linkComponent,'span');

    expect(date.textContent).toEqual('Saveing...');
  });
});
