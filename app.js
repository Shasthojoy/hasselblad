if(process.env.NODETIME_ACCOUNT_KEY) {
  require('nodetime').profile({
    accountKey: process.env.NODETIME_ACCOUNT_KEY,
    appName: 'Hasselblad'
  });
}

// Start sails and pass it command line arguments
require('sails').lift(require('optimist').argv);
