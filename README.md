# active-window
> Get active window title in Node.js.

Compatible with Linux, Windows 7+, and OSX;

## Usage

```javascript
const {ActiveWindowTracker} = require('active-window');

const activeWindowTracker = new ActiveWindowTracker();

activeWindowTracker.registerListener(e => {
  console.log(e);
})

activeWindowTracker.start();

setTimeout(() => {
  activeWindowTracker.stop();
}, 3000);

```
## Tested on
- Windows
 - Windows 10
 - Windows 7
- Linux 
  - Raspbian [lxdm]
  - Debian 8 [cinnamon]
- OSX
  - Yosemite 10.10.1

## TODO

- Test on more operating systems.
- Use native APIs. 

## License

MIT
