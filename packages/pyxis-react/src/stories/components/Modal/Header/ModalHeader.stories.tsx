import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Header, {HeaderProps} from "components/Modal/Header";
import Badge from "components/Badge";
import {IconBook} from "components/Icon/Icons";
import styles from "../ModalStories.module.scss";

export default {
  title: 'Components/Modal/Modal.Header Stories',
  component: Header,
  argTypes: {
    onClose: {
      action: 'Close clicked',
      table:  { disable: true },
      description: "The Modal component automatically pass `onClose` function to `Modal.Header`, so you shouldn't populate this prop."
    },
    id: {
      table:  { disable: true },
      description: "The Modal component automatically generates an `id` for its children, so you shouldn't pass it to `Modal.Header`"
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
} as ComponentMeta<typeof Header>;

const Template:ComponentStory<typeof Header> = (args:HeaderProps) => <Header {...args}/>

export const HeaderDefault = Template.bind({})
HeaderDefault.args = {
  title: "Modal Title",
}

export const WithBadge = Template.bind({})
WithBadge.args = {
  title: "Modal Title",
  badge: <Badge variant={"brand"}>Badge</Badge>
}

export const WithIcon = Template.bind({})
WithIcon.args = {
  title: "Modal Title",
  icon: <IconBook className="c-brand-base"/>
}

export const StickyHeader = Template.bind({})
StickyHeader.args = {
  title: "Modal Title",
  isSticky: true
}

export const CustomHeader = Template.bind({})
CustomHeader.args = {
  children: <div className={"title-s-book"}>This is a custom Header</div>
}
