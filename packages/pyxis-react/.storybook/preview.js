/* jshint node: true */
const {sortStories} = require("./sortStories");

const customViewports = {
  xxsmall: {
    name: '01 - xxsmall',
    styles: {
      width: '375px',
      height: '100%'
    },
  },
  xsmall: {
    name: '02 - xsmall',
    styles: {
      width: '576px',
      height: '100%'
    },
  },
  small: {
    name: '03 - small',
    styles: {
      width: '768px',
      height: '100%'
    },
  },
  medium: {
    name: '04 - medium',
    styles: {
      width: '992px',
      height: '100%'
    },
  },
  large: {
    name: '05 - large',
    styles: {
      width: '1200px',
      height: '100%'
    },
  },
  xlarge: {
    name: '06 - xlarge',
    styles: {
      width: '1680px',
      height: '100%'
    },
  },
};

module.exports = {
  parameters: {
    actions: { argTypesRegex: "^on[A-Z].*" },
    backgrounds: { values: [
        { name: 'light', value: '#ffffff' },
        { name: 'neutral95', value: '#f3f4f4' },
        { name: 'dark', value: '#21283b' },
      ]
    },
    controls: {
      expanded: true,
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/,
      },
    },
    options: {
      storySort: sortStories(
        [
          ['Introduction', 'Foundations', 'Components'], // 1. level
          ['Color', 'Typography', 'Spacing', 'Radius', 'Elevation', '...'], // 2. level
          ['Overview', '...', 'All Stories'] // 3. level
        ]
      ),
    },
    viewport: {
      viewports: {
        ...customViewports,
      },
    },
  },
};
