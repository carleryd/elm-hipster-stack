# emojis-list

[![Dependency status](http://img.shields.io/david/Kikobeats/emojis-list.svg?style=flat-square)](https://david-dm.org/Kikobeats/emojis-list)
[![Dev Dependencies Status](http://img.shields.io/david/dev/Kikobeats/emojis-list.svg?style=flat-square)](https://david-dm.org/Kikobeats/emojis-list#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/emojis-list.svg?style=flat-square)](https://www.npmjs.org/package/emojis-list)
[![Gittip](http://img.shields.io/gittip/Kikobeats.svg?style=flat-square)](https://www.gittip.com/Kikobeats/)

> Complete list of standard Unicode codes that represent emojis.

The file content all shortcuts declared that you can use for invoke a emoji.

## Install

```bash
npm install emojis-list --save
```

If you want to use in the browser (powered by [Browserify](http://browserify.org/)):

```bash
bower install emojis-list --save
```

and later link in your HTML:

```html
<script src="bower_components/emojis-list/dist/emojis-list.js"></script>
```

## Usage

```
var emojis = require('emojis-list');
console.log(emojis[0]);
// => 🀄
```

## License

MIT © [Kiko Beats](http://www.kikobeats.com)
