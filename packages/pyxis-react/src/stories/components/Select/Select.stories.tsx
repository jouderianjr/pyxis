import React from 'react';
import {ComponentMeta} from '@storybook/react';
import Select from './Select';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";

export default {
  title: 'Components - Form/Select 🚧/All Stories',
} as ComponentMeta<typeof Select>;

export const Default = () => <div style={{marginBottom: 155}}><Select /></div>
Default.parameters = renderSourceAsHTML(Default());

export const WithError = () => <Select error />
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <Select hint />
WithHint.parameters = renderSourceAsHTML(WithHint());

export const WithDisabled = () => <Select disabled />
WithDisabled.parameters = renderSourceAsHTML(WithDisabled());

export const Native = () => <Select native />
Native.parameters = renderSourceAsHTML(Native());

export const WithAccessibleLabel = () => <Select id="label-and-select" withLabel />
WithAccessibleLabel.parameters = renderSourceAsHTML(WithAccessibleLabel());
