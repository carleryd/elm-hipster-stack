jest.unmock('../../web/static/js/shared/urlPrettify');
import urlPrettify from '../../web/static/js/shared/urlPrettify';

describe('urlPrettify', () => {
  it('should work for http addresses', () => {
    const actual = urlPrettify('http://reactkungfu.com');
    const expected = 'reactkungfu.com';
    expect(actual).toEqual(expected);
  });

  it('should work for https addresses', () => {
    const actual = urlPrettify('https://facebook.github.io');
    const expected = 'facebook.github.io';
    expect(actual).toEqual(expected);
  });

  it('should remove trailing slashes', () => {
    const actual = urlPrettify('https://facebook.github.io/react/');
    const expected = 'facebook.github.io/react';
    expect(actual).toEqual(expected);
  });
});
