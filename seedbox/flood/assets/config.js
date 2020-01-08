// Default configuration, with passwords from env variables
// but a default (randomly generated) password is used in backup
const CONFIG = {
  baseURI: process.env.WEBROOT || '/',
  floodServerHost: '0.0.0.0',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/app/flood/flood-db/',
  floodServerPort: 3000,
  maxHistoryStates: 120,
  pollInterval: 1000 * 5,
  secret: process.env.FLOOD_SECRET || 'wbeasTfINGYANDrExtrIm',
  ssl: process.env.FLOOD_ENABLE_SSL === 'true' || process.env.FLOOD_ENABLE_SSL === true,
  scgi: {
    host: 'rtorrent',
    port: 5000,
    socket: false
  }
};

module.exports = CONFIG;

//    socketPath: process.env.RTORRENT_HOME + '/session/rtorrent.socket' ||'/tmp/rtorrent.socket'

