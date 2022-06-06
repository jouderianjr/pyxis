import React from 'react';
import {ComponentMeta} from '@storybook/react';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import Accordion from "./Accordion";

export default {
  title: 'Components/Accordion 🚧/All Stories',
} as ComponentMeta<typeof Accordion>;

export const Default = () => <Accordion id="default" />
Default.parameters = renderSourceAsHTML(Default());

export const TitleOnly = () => <Accordion id="with-no-subtext" hasSubtext={false} hasActionText={false}/>
TitleOnly.parameters = renderSourceAsHTML(TitleOnly());

export const WithIcon = () => <Accordion id="with-icon" hasIcon />
WithIcon.parameters = renderSourceAsHTML(WithIcon());

export const WithImage = () => <Accordion id="with-image" hasImage />
WithImage.parameters = renderSourceAsHTML(WithImage());

export const WithActionText = () => <Accordion id="with-action" hasActionText hasIcon />
WithActionText.parameters = renderSourceAsHTML(WithActionText());

export const WithLightBackground = () => <Accordion id="with-color" color="white" hasIcon />
WithLightBackground.parameters = {
  backgrounds: { default: 'neutral95' },
  ...renderSourceAsHTML(WithLightBackground())
}

export const AltBackground = () => <Accordion id="with-alt" alt hasIcon />
AltBackground.parameters = {
  backgrounds: { default: 'dark' },
  ...renderSourceAsHTML(AltBackground())
}
