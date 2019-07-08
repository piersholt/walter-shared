# wilhelm-tools ![GitHub](https://img.shields.io/github/license/piersholt/wilhelm-tools.svg)

Tooling to support the package [Wilhelm](https://github.com/piersholt/walter), associated software [Wolfgang](https://github.com/piersholt/wolfgang), and the project [Walter](https://github.com/piersholt/walter).

---

## Tools

### Yabber

Messaging library for network, and inter-process communication. Largely a wrapper for ZeroMQ (via rbczmq). Includes service specific APIs for use by [Wilhelm](https://github.com/piersholt/walter) and [Wolfgang](https://github.com/piersholt/wolfgang).

### LogActually

A micro logging library based on Ruby's Logger. Some pretty formatting, and granular log level control.

P.S. Turns out that LogActually is fundamentally flawed...
> One Log to rule them all, One Log to find them, One Log to #close them all, and in the darkness bork them.

## License

wilhelm-tools is released under the [MIT License](https://opensource.org/licenses/MIT).

## About

This program uses the [Ruby D-Bus](https://github.com/mvidner/ruby-dbus) library, which is licensed under the GNU Lesser General Public Library, version 2.1, or any later version.
