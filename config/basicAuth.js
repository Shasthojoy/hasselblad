module.exports.basicAuth = {
  username: process.env.BASIC_AUTH_USERNAME,
  password: process.env.BASIC_AUTH_PASSWORD,
  enabled: process.env.NODE_ENV === 'production'
};