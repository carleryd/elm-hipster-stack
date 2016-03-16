jest.dontMock('./super-mega');
const superMega = require('./super-mega');

describe('superMega', () => {
  it('should return super mega style string', () => {
    const actual = superMega();
    const expected = 'Super MEEEGA!';
    expect(actual).toEqual(expected);
  });
});
