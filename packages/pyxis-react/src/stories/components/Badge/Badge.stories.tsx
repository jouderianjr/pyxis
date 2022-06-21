import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Badge, {BadgeProps} from "components/Badge";

export default {
  title: 'Components - Display/Badge/All Stories',
  component: Badge,
  argTypes: {
    variant: {
      description: "Please use `neutralGradient` and `brandGradient` only without the `alt` prop. " +
        "Instead, `ghost` variant will be visible only on dark background."
    }
  }
} as ComponentMeta<typeof Badge>;

const Template: ComponentStory<typeof Badge> = (args: BadgeProps) => <Badge {...args}>Badge Text</Badge>;

export const Default = Template.bind({})

export const AltBackground = Template.bind({})
AltBackground.args = {
  alt: true,
};

AltBackground.parameters = {
  backgrounds: { default: 'dark' },
};
