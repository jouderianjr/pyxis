import React from 'react';
import {ComponentMeta} from '@storybook/react';
import DateField from './DateField';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";

export default {
  title: 'Components - Form/Date Field 🚧/All Stories',
} as ComponentMeta<typeof DateField>;

export const Default = () => <DateField />
Default.parameters = renderSourceAsHTML(Default());

export const WithError = () => <DateField error />
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <DateField hint />
WithHint.parameters = renderSourceAsHTML(WithHint());

export const WithDisabled = () => <DateField disabled />
WithDisabled.parameters = renderSourceAsHTML(WithDisabled());

export const WithAccessibleLabel = () => <DateField id="label-and-date-field" withLabel />
WithAccessibleLabel.parameters = renderSourceAsHTML(WithAccessibleLabel());
