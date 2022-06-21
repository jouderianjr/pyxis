import React from 'react';
import {ComponentMeta} from '@storybook/react';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import Toggle from "./Toggle";

export default {
  title: 'Components - Control/Toggle 🚧/All Stories',
} as ComponentMeta<typeof Toggle>;

export const Default = () => <Toggle id="toggle-id"/>
Default.parameters = renderSourceAsHTML(Default());

export const WithLabel = () => <Toggle label id="toggle-id-label"/>
WithLabel.parameters = renderSourceAsHTML(WithLabel());

export const Disabled = () => <Toggle disabled id="toggle-id-disabled"/>
Disabled.parameters = renderSourceAsHTML(Disabled());
