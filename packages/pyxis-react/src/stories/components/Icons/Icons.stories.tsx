import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import { IconPrimaLogo } from 'components/Icon/Icons';
import { IconProps } from 'components/Icon';

export default {
  title: 'Components - Display/Icon/All Stories',
  component: IconPrimaLogo,
  argTypes: {
    size: {
      options: ['s', 'm', 'l'],
      control: { type: 'select' },
      table: {
        category: 'Customization',
      },
    },
    boxedVariant: {
      options: ['neutral', 'brand', 'success', 'alert', 'error'],
      control: { type: 'select' },
      table: {
        category: 'Customization',
      },
    },
    alt: {
      control: { type: 'boolean' },
      table: {
        category: 'Customization',
      },
    },
    className: {
      control: { type: 'text' },
      table: {
        category: 'Customization',
      },
    },
    description: {
      description: 'Set an accessible description that will be read by screen readers.',
      control: { type: 'text' },
      table: {
        category: 'Accessibility',
      },
    },
  }
} as ComponentMeta<typeof IconPrimaLogo>;

const Template: ComponentStory<typeof IconPrimaLogo> = (args: IconProps) => <IconPrimaLogo {...args} />;

export const Default = Template.bind({});

export const Boxed = Template.bind({});
Boxed.args = {
  description: 'Icon description for screen reader',
  boxedVariant: 'neutral',
};

export const BoxedBrand = Template.bind({});
BoxedBrand.args = {
  description: 'Icon description for screen reader',
  boxedVariant: 'brand',
};

export const BoxedSuccess = Template.bind({});
BoxedSuccess.args = {
  description: 'Icon description for screen reader',
  boxedVariant: 'success',
};

export const BoxedAlert = Template.bind({});
BoxedAlert.args = {
  description: 'Icon description for screen reader',
  boxedVariant: 'alert',
};

export const BoxedError = Template.bind({});
BoxedError.args = {
  description: 'Icon description for screen reader',
  boxedVariant: 'error',
};

export const Alt = Template.bind({});
Alt.args = {
  alt: true,
  description: 'Icon description for screen reader',
};

Alt.parameters = {
  backgrounds: { default: 'dark' },
};
