import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Footer, {FooterProps} from "components/Modal/Footer";
import Button from "components/Button";
import styles from "../ModalStories.module.scss";

export default {
  title: 'Components/Modal/Modal.Footer Stories',
  component: Footer,
  argTypes: {
    id: {
      table: {disable: true},
    }
  },
  parameters: {
    backgrounds: { default: 'neutral95' },
  },
  decorators: [
    (Story) => (
      <div className={styles.storyWrapper}>
        <Story />
      </div>
    ),
  ],
} as ComponentMeta<typeof Footer>;

const Template:ComponentStory<typeof Footer> = (args:FooterProps) => <Footer {...args}/>

export const FooterDefault = Template.bind({})
FooterDefault.args = {
  buttons: <>
    <Button variant={"secondary"}>Secondary</Button>
    <Button variant={"primary"}>Primary</Button>
  </>,
}

export const WithText = Template.bind({})
WithText.args = {
  buttons: <>
    <Button variant={"secondary"}>Secondary</Button>
    <Button variant={"primary"}>Primary</Button>
  </>,
  text: "Custom additional text"
}

export const WithFullWidthButtons = Template.bind({})
WithFullWidthButtons.args = {
  buttons: <>
    <Button variant={"secondary"}>Secondary</Button>
    <Button variant={"primary"}>Primary</Button>
  </>,
  hasFullWidthButtons: true
}
WithFullWidthButtons.parameters = {
  viewport: { defaultViewport: "xxsmall" }
}

export const StickyFooter = Template.bind({})
StickyFooter.args = {
  buttons: <>
    <Button variant={"secondary"}>Secondary</Button>
    <Button variant={"primary"}>Primary</Button>
  </>,
  isSticky: true
}

export const AltFooter = Template.bind({})
AltFooter.args = {
  buttons: <>
    <Button variant={"secondary"} alt>Secondary</Button>
    <Button variant={"primary"} alt>Primary</Button>
  </>,
  alt: true
}

export const CustomFooter = Template.bind({})
CustomFooter.args = {
  children: <div className={"title-s-book"}>This is a custom Footer</div>
}
