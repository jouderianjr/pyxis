import React from 'react';
import {ComponentMeta} from '@storybook/react';
import TextArea from './TextArea';
import renderSourceAsHTML from "../../utils/renderSourceAsHTML";

export default {
  title: 'Components - Form/Text Area 🚧/All Stories',
} as ComponentMeta<typeof TextArea>;

export const Default = () => <TextArea />
Default.parameters = renderSourceAsHTML(Default());

export const WithError = () => <TextArea error />
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <TextArea hint />
WithHint.parameters = renderSourceAsHTML(WithHint());

export const WithDisabled = () => <TextArea disabled />
WithDisabled.parameters = renderSourceAsHTML(WithDisabled());

export const WithAccessibleLabel = () => <TextArea id="label-and-textarea" withLabel />
WithAccessibleLabel.parameters = renderSourceAsHTML(WithAccessibleLabel());
