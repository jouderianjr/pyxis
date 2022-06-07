import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Form from 'components/Form';
import Label, {LabelProps} from "components/Form/Label";

export default {
  title: 'Components/Label/All Stories',
  component: Form.Label,
} as ComponentMeta<typeof Label>;

const Template:ComponentStory<typeof Form.Label> = (args:LabelProps) => <Label {...args} >Label</Label>;

export const InsideFormItem = () =>
  <Form.Item id="item-id">
    <Form.Label>Label</Form.Label>
    <Form.Input placeholder="Input field"/>
  </Form.Item>;
InsideFormItem.parameters = {
  controls: { hideNoControlsWarning: true },
};

export const Default = Template.bind({});

export const WithSubtext = Template.bind({});
WithSubtext.args = {
  subText: "This is a label subtext."
}

export const SmallSize = Template.bind({});
SmallSize.args = {
  size: "small"
}
