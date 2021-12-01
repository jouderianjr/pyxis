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
    "@storybook/addon-a11y",
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@storybook/preset-create-react-app",
  ],
};
