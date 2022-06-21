import React from 'react';
import {ComponentMeta} from '@storybook/react';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import Legend from "./Legend";

export default {
  title: 'Components - Form/Legend 🚧/All Stories',
} as ComponentMeta<typeof Legend>;

export const Default = () => (
  <Legend />
)
Default.parameters = renderSourceAsHTML(Default());

export const WithDescription = () => (
  <Legend withDescription />
)
WithDescription.parameters = renderSourceAsHTML(WithDescription());

export const WithIcon = () => (
  <Legend withDescription withIcon />
)
WithIcon.parameters = renderSourceAsHTML(WithIcon());

export const WithImage = () => (
  <Legend withDescription withImage />
)
WithImage.parameters = renderSourceAsHTML(WithImage());

export const AlignLeft = () => (
  <Legend withDescription withImage alignLeft />
)
AlignLeft.parameters = renderSourceAsHTML(AlignLeft());