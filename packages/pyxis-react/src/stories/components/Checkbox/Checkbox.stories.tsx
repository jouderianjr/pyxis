import React from 'react';
import {ComponentMeta} from '@storybook/react';
import Checkbox, {CheckboxGroup} from "./Checkbox";
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";

export default {
  title: 'Components - Control/Checkbox 🚧/All Stories',
} as ComponentMeta<typeof CheckboxGroup>;

export const Default = () => <CheckboxGroup />
Default.parameters = renderSourceAsHTML(Default());

export const WithError = () => <CheckboxGroup error/>
WithError.parameters = renderSourceAsHTML(WithError());

export const WithHint = () => <CheckboxGroup hint/>
WithHint.parameters = renderSourceAsHTML(WithHint());

export const Disabled = () => <CheckboxGroup disabled/>
Disabled.parameters = renderSourceAsHTML(Disabled());

export const VerticalLayout = () => <CheckboxGroup layout="vertical"/>
VerticalLayout.parameters = renderSourceAsHTML(VerticalLayout());

export const WithoutGroup = () => (
  <div className="form-item">
    <div className="form-item__wrapper">
      <Checkbox />
    </div>
  </div>
);
WithoutGroup.parameters = renderSourceAsHTML(WithoutGroup());
