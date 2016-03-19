export default (url) => {
  return url.replace(/^https?:\/\/|\/$/ig,'');
};
