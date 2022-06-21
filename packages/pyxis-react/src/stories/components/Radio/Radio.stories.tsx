import React from 'react';
import {ComponentMeta} from '@storybook/react';
import {RadioGroup} from "./Radio";
import renderSourceAsHTML from "../../utils/renderSourceAsHTML";

export default {
  title: 'Components - Control/Radio 🚧/All Stories',
} as ComponentMeta<typeof RadioGroup>;

export const Default = () => <RadioGroup name="default"/>
Default.parameters = renderSourceAsHTML(Default());

export const WithError = () => <RadioGroup name="error" error/>
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <RadioGroup name="hint" hint/>
WithHint.parameters = renderSourceAsHTML(WithHint());

export const Disabled = () => <RadioGroup name="disabled" disabled/>
Disabled.parameters = renderSourceAsHTML(Disabled());

export const VerticalLayout = () => <RadioGroup name="vertical" layout="vertical"/>
VerticalLayout.parameters = renderSourceAsHTML(VerticalLayout());
