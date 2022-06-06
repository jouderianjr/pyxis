/* jshint node: true */
const stories =
  process.env.STORYBOOK_ENV === 'TEST'
  ? ["../src/**/Test.stories.@(ts|tsx|mdx)"]
  : [
    "../src/stories/Introduction.stories.mdx",
    "../src/**/!(Test).stories.@(ts|tsx|mdx)"
  ];

module.exports = {
  stories,
  addons: [
    {
        name: "@storybook/addon-essentials",
        options: {
            actions: false,
        }
    },
    '@whitespace/storybook-addon-html',
    "@storybook/addon-a11y",
    "@storybook/addon-links",
    "@storybook/preset-create-react-app",
  ],
};
