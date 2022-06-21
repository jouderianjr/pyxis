import React from 'react';
import {ComponentMeta} from '@storybook/react';
import {RadioCardGroup} from "./RadioCard";
import renderSourceAsHTML from "../../utils/renderSourceAsHTML";

export default {
  title: 'Components - Control/RadioCard 🚧/All Stories'
} as ComponentMeta<typeof RadioCardGroup>;

export const Default = () => <RadioCardGroup name="default"/>
Default.parameters = renderSourceAsHTML(Default());

export const WithError = () => <RadioCardGroup name="error" error/>
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <RadioCardGroup name="hint" hint/>
WithHint.parameters = renderSourceAsHTML(WithHint());

export const Disabled = () => <RadioCardGroup name="disabled" disabled/>
Disabled.parameters = renderSourceAsHTML(Disabled());

export const WithIcon = () => <RadioCardGroup name="with-icon" addon/>
WithIcon.parameters = renderSourceAsHTML(WithIcon());

export const WithTextAddon = () => <RadioCardGroup name="text-addon" priceAddon />
WithTextAddon.parameters = renderSourceAsHTML(WithTextAddon());

export const LargeSize = () => <RadioCardGroup name="large" isLarge/>
LargeSize.parameters = renderSourceAsHTML(LargeSize());

export const HorizontalLayout = () => <RadioCardGroup name="default" layout="horizontal"/>
HorizontalLayout.parameters = renderSourceAsHTML(HorizontalLayout());

export const VerticalLayout = () => <RadioCardGroup name="default" layout="vertical"/>
VerticalLayout.parameters = renderSourceAsHTML(VerticalLayout());
