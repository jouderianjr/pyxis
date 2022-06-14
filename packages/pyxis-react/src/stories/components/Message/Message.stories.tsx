import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Message from "components/Message";
import {MessageProps} from "components/Message/Message";
import {IconCalendar} from "components/Icon/Icons";

export default {
  title: 'Components/Message/All Stories',
  component: Message,
  argTypes: {
    hasColoredBackground: {
      description: "Not available with `ghost` variant"
    },
    title: {
      description: "Not available with `ghost` variant"
    },
    variant: {
      description: "The `alert` variant is available only with the colored background."
    }
  }
} as ComponentMeta<typeof Message>;

const Template:ComponentStory<typeof Message> = (args:MessageProps) => <Message {...args}>Message description</Message>

export const Default = Template.bind({})
Default.args = {
  title: "Message title"
}

export const WithColoredBackground = Template.bind({})
WithColoredBackground.args = {
  hasColoredBackground: true,
  variant: "success"
}

export const WithCustomIcon = Template.bind({})
WithCustomIcon.args = {
  customIcon: IconCalendar
}

export const DismissibleMessage = Template.bind({})
DismissibleMessage.args = {
  onClose: () => window.alert("close"),
  onCloseAccessibleLabel: "Close Message"
}

