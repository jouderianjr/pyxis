import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Form from 'components/Form';
import {ItemProps} from "components/Form/Item";

export default {
  title: 'Components - Form/Item/All Stories',
  component: Form.Item,
  argTypes: {
    children: {
      table: { disable: true }
    }
  }
} as ComponentMeta<typeof Form.Item>;

const Template:ComponentStory<typeof Form.Item> = (args:ItemProps) => <Form.Item {...args}>{args.children}</Form.Item>;

export const Default = () =>
  <Form.Item id="item-id" hint="This is a hint.">
    <Form.Label>Label</Form.Label>
    <Form.Input placeholder="Input field"/>
  </Form.Item>;
Default.parameters = {
  controls: { hideNoControlsWarning: true },
};

export const WithLabelAndInput = Template.bind({});
WithLabelAndInput.args = {
  id: "default-id",
  children: [
      <Form.Label>Label</Form.Label>,
      <Form.Input placeholder="Input field" />
  ]
}

export const WithHint = Template.bind({});
WithHint.args = {
  id: "hint-id",
  children: [
      <Form.Label>Label</Form.Label>,
      <Form.Input placeholder="Input field" />
  ],
  hint: "This is an hint."
}

export const WithError = Template.bind({});
WithError.args = {
  id: "error-id",
  children: [
      <Form.Label>Label</Form.Label>,
      <Form.Input placeholder="Input field" />
  ],
  errorMessage: "There is an error."
}

export const WithAdditionalContent = Template.bind({});
WithAdditionalContent.args = {
  id: "additional-id",
  children: [
      <Form.Label>Label</Form.Label>,
      <Form.Input placeholder="Input field" />,
      <Form.AdditionalContent>
        This is an additional content.
      </Form.AdditionalContent>
  ]
}
