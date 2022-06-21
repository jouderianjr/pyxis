import React from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Input, {InputProps} from "components/Form/Input";
import Form from 'components/Form';
import {IconCar} from "components/Icon/Icons";

export default {
  title: 'Components - Form/Input/All Stories',
  component: Form.Input,
  argTypes: {
    addon: {
      description: "It could be a `string` or an `Icon`"
    },
    errorId: {
      description: "Use it only when Input is outside a `Form.Item`"
    },
    hasError: {
      description: "Use it only when Input is outside a `Form.Item`"
    },
    hintId: {
      description: "Use it only when Input is outside a `Form.Item`"
    }
  }
} as ComponentMeta<typeof Form.Input>;

const Template:ComponentStory<typeof Form.Input> = (args:InputProps) => <Input aria-label="Accessibility label" placeholder="Input field" {...args} />;

export const InsideFormItem = () =>
  <Form.Item id="item-id">
    <Form.Label>Label</Form.Label>
    <Form.Input placeholder="Input field"/>
  </Form.Item>;
InsideFormItem.parameters = {
  controls: { hideNoControlsWarning: true },
};

export const Default = Template.bind({});

export const WithError = Template.bind({});
WithError.args = {
  hasError: true
}

export const Disabled = Template.bind({});
Disabled.args = {
  disabled: true
}

export const WithPrependIcon = Template.bind({});
WithPrependIcon.args ={
  addon: IconCar
}
WithPrependIcon.parameters = {
  docs: {
    source: {
      code: `<Input
  addon={IconCar} 
  aria-label="Accessibility label"
  placeholder="Input field"
/>
      `,
    },
  },
}

export const WithAppendIcon = Template.bind({});
WithAppendIcon.args ={
  addon: IconCar,
  addonPlacement: "append"
}
WithAppendIcon.parameters = {
  docs: {
    source: {
      code: `<Input
  addon={IconCar} 
  addonPlacement="append"
  aria-label="Accessibility label"
  placeholder="Input field"
/>
      `,
    },
  },
}

export const WithPrependText = Template.bind({});
WithPrependText.args ={
  addon: "text",
}

export const WithAppendText = Template.bind({});
WithAppendText.args ={
  addon: "text",
  addonPlacement: "append"
}

export const WithSmallSize = Template.bind({});
WithSmallSize.args = {
  size: "small"
}

