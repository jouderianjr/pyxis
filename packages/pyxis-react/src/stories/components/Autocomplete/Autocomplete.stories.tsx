import React from 'react';
import {ComponentMeta} from '@storybook/react';
import Autocomplete from './Autocomplete';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";

export default {
  title: 'Components - Form/Autocomplete 🚧/All Stories',
} as ComponentMeta<typeof Autocomplete>;

export const Default = () => <div style={{marginBottom: 155}}><Autocomplete /></div>
Default.parameters = renderSourceAsHTML(Default());

export const WithInitialValue = () => <Autocomplete initialValue="Italy" />
WithInitialValue.parameters = renderSourceAsHTML(WithInitialValue());

export const WithError = () => <Autocomplete error />
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <Autocomplete hint />
WithHint.parameters = renderSourceAsHTML(WithHint());

export const WithDisabled = () => <Autocomplete disabled />
WithDisabled.parameters = renderSourceAsHTML(WithDisabled());

export const WithSuggestion = () => <Autocomplete withSuggestion />
WithSuggestion.parameters = renderSourceAsHTML(WithSuggestion());

export const WithHeader = () => <Autocomplete withHeader />
WithHeader.parameters = renderSourceAsHTML(WithHeader());

export const NoResultAction = () => <Autocomplete noResultAction />
NoResultAction.parameters = renderSourceAsHTML(NoResultAction());
