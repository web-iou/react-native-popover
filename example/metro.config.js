const path = require('path');
const { getDefaultConfig } = require('@react-native/metro-config');
const { withMetroConfig } = require('react-native-monorepo-config');

const root = path.resolve(__dirname, '..');

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
module.exports = withMetroConfig(
  {
    ...getDefaultConfig(__dirname),
    resolver: {
      nodeModulesPaths: [
        path.resolve(__dirname, 'node_modules')
      ],
      disableHierarchicalLookup: true
    },
    watchFolders: [
      path.resolve(__dirname) // 只监听当前目录
    ],
  },
  {
    root,
    dirname: __dirname,
  }
);
