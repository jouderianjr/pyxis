import React from 'react';
import {ComponentMeta} from '@storybook/react';
import {CheckboxCardGroup} from "./CheckboxCard";
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";

export default {
  title: 'Components - Control/CheckboxCard 🚧/All Stories'
} as ComponentMeta<typeof CheckboxCardGroup>;

export const Default = () => <CheckboxCardGroup />
Default.parameters = renderSourceAsHTML(Default());

export const WithError = () => <CheckboxCardGroup error/>
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <CheckboxCardGroup hint/>
WithHint.parameters = renderSourceAsHTML(WithHint());

export const Disabled = () => <CheckboxCardGroup disabled/>
Disabled.parameters = renderSourceAsHTML(Disabled());

export const WithIcon = () => <CheckboxCardGroup addon/>
WithIcon.parameters = renderSourceAsHTML(WithIcon());

export const WithTextAddon = () => <CheckboxCardGroup priceAddon />
WithTextAddon.parameters = renderSourceAsHTML(WithTextAddon());

export const LargeSize = () => <CheckboxCardGroup isLarge/>
LargeSize.parameters = renderSourceAsHTML(LargeSize());

export const HorizontalLayout = () => <CheckboxCardGroup layout="horizontal"/>
HorizontalLayout.parameters = renderSourceAsHTML(HorizontalLayout());

export const VerticalLayout = () => <CheckboxCardGroup layout="vertical"/>
VerticalLayout.parameters = renderSourceAsHTML(VerticalLayout());
