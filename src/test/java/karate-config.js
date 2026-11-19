function fn() {
  var env = karate.env; // -Dkarate.env=qa
  karate.log('karate.env =', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: 'https://jsonplaceholder.typicode.com'
  };
  if (env == 'qa') {
    // config.baseUrl = 'https://qa.mi-api.com';
  } else if (env == 'prod') {
    // config.baseUrl = 'https://mi-api.com';
  }
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);
  return config;
}
