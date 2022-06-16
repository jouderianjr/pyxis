import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import ButtonCard, {ButtonCardProps} from "components/ButtonCard";
import {IconDownload} from "components/Icon/Icons";

export default {
  title: 'Components/ButtonCard/All Stories',
  component: ButtonCard,
} as ComponentMeta<typeof ButtonCard>;

const Template: ComponentStory<typeof ButtonCard> = (args: ButtonCardProps) => <ButtonCard {...args} />;

const children = "Button title";
const icon = IconDownload;

export const Default = Template.bind({})
Default.args = {
  children,
  icon,
  subtitle: "Subtitle",
};

export const WithoutSubtitle = Template.bind({})
WithoutSubtitle.args = {
  children,
  icon,
};

export const Loading = Template.bind({})
Loading.args = {
  children,
  icon,
  loading: true,
};

export const Disabled = Template.bind({})
Disabled.args = {
  children,
  disabled: true,
  icon,
};

export const AltBackground = Template.bind({})
AltBackground.args = {
  alt: true,
  children,
  icon,
};
AltBackground.parameters = { backgrounds: { default: 'dark' } };

export const WithHref = Template.bind({})
WithHref.args = {
  children,
  download: true,
  href: "logo.svg",
  icon,
  title: "Download logo",
};