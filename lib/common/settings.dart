
const String network_name_kusama = 'kusama';
const String network_name_polkadot = 'polkadot';

const int kusama_token_decimals = 12;
const int acala_token_decimals = 18;

const int dot_re_denominate_block = 1248328;

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year


/// app versions
const String app_beta_version = 'v1.0.4-beta.1';
const int app_beta_version_code = 1041;

/// js code versions
const Map<String, int> js_code_version_map = {
  network_name_polkadot: 10010,
  network_name_kusama: 10010,
};

/// graphql for laminar
const GraphQLConfig = {
  'httpUri': 'https://indexer.laminar-chain.laminar.one/v1/graphql',
  'wsUri': 'wss://indexer.laminar-chain.laminar.one/v1/graphql',
};
const Map<String, String> margin_pool_name_map = {
  '0': 'Laminar',
  '1': 'Crypto',
  '2': 'FX',
};
const Map<String, String> synthetic_pool_name_map = {
  '0': 'Laminar',
  '1': 'Crypto',
  '2': 'FX',
};
const Map<String, String> laminar_leverage_map = {
  'Two': 'x2',
  'Three': 'x3',
  'Five': 'x5',
  'Ten': 'x10',
  'Twenty': 'x20',
};
final BigInt laminarIntDivisor = BigInt.parse('1000000000000000000');
