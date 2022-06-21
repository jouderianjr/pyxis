import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Button from 'components/Button';
import {ButtonFC} from "components/Button/types";
import {IconPen} from "components/Icon/Icons";

const table = (defaultValue: string | boolean) => ({
  category: "Customization",
  defaultValue: {
    summary: defaultValue
  },
})

export default {
  title: 'Components - Action/Button/All Stories',
  argTypes: {
    variant: {
      options: ['primary', 'secondary', 'tertiary', 'brand', 'ghost'],
      description: "Variants set the visual style of the button, each button should have a visual hierarchy in the page.\n\n`primary` `secondary` `tertiary` `brand` `ghost`",
      control: {
        type: 'select'
      },
      table: table('primary')
    },
    size: {
      options: ['small', 'medium', 'large', 'huge'],
      description: "Sizes set the occupied space of the button.\n\n`small` `medium` `large` `huge`",
      control: {
        type: 'select'
      },
      table: table('medium')
    },
    loading: {
      description: "Adds a loading animation to the button.\n\n`boolean`",
      control: {
        type: 'boolean'
      },
      table: table(false)
    },
    shadow: {
      description: "Adds a shadow to the button.\n\n`boolean`",
      control: {
        type: 'boolean'
      },
      table: table(false)
    },
    contentWidth: {
      description: "Remove the min-width to the button.\n\n`boolean`",
      control: {
        type: 'boolean'
      },
      table: table(false)
    },
    iconPlacement: {
      options: ['prepend', 'append', 'only'],
      description: "Buttons can also accommodate an icon. The icon can be inserted in the append or prepend of the label. The button can also contain only the icon\n\n`prepend` `append` `only`",
      control: {
        type: 'select'
      },
      table: table('prepend')
    },
    alt: {
      defaultValue: false,
      description: "Use on dark background.\n\n`boolean`",
      control: {
        type: 'boolean'
      },
      table: table(false)
    },
    dataTestId: {
      table: { disable: true }
    },
    icon: {
      table: { disable: true }
    }
  }
} as ComponentMeta<typeof Button>;

const Template: ComponentStory<ButtonFC> = args => <Button {...args}>Text</Button>

const size = "medium";
const iconPlacement = "prepend";

export const Primary = Template.bind({});
Primary.args = {
  variant: "primary",
  size,
  iconPlacement
};

export const Secondary = Template.bind({});
Secondary.args = {
  variant: "secondary",
  size,
  iconPlacement
};

export const Tertiary = Template.bind({});
Tertiary.args = {
  variant: "tertiary",
  size,
  iconPlacement
};

export const Brand = Template.bind({});
Brand.args = {
  variant: "brand",
  size,
  iconPlacement
};

export const Ghost = Template.bind({});
Ghost.args = {
  variant: "ghost",
  size,
  iconPlacement
};

export const Icon = Template.bind({});
Icon.args = {
  variant: "primary",
  icon: IconPen,
  size,
  iconPlacement
};

export const IconOnly = Template.bind({});
IconOnly.args = {
  variant: "primary",
  children: "Accessible description",
  iconPlacement: "only",
  icon: IconPen,
  size
};

export const WithShadow = Template.bind({});
WithShadow.args = {
  shadow: true,
  size,
  iconPlacement
};

export const Loading = Template.bind({});
Loading.args = {
  loading: true,
  size,
  iconPlacement
};

export const ContentWidth = Template.bind({});
ContentWidth.args = {
  contentWidth: true,
  size,
  iconPlacement
};

export const AltBackground = Template.bind({});
AltBackground.args = {
  alt: true,
  size,
  iconPlacement
};

AltBackground.parameters = {
  backgrounds: { default: 'dark' },
};
