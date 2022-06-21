import React from 'react';
import {ComponentMeta} from '@storybook/react';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import TextSwitch from "./TextSwitch";

export default {
  title: 'Components - Control/TextSwitch 🚧/All Stories',
} as ComponentMeta<typeof TextSwitch>;

export const Default = () => <TextSwitch name="default" />
Default.parameters = renderSourceAsHTML(Default());

export const EqualWidthOptions = () => <TextSwitch name={"equal"} optionWidth="equal"/>
EqualWidthOptions.parameters = renderSourceAsHTML(EqualWidthOptions());

export const WithLabel = () => <TextSwitch name={"label"} hasLabel />
WithLabel.parameters = renderSourceAsHTML(WithLabel());

export const LabelOnTopLeft = () => <TextSwitch name={"labelTop"} hasLabel labelPosition="topLeft" />
LabelOnTopLeft.parameters = renderSourceAsHTML(LabelOnTopLeft());

export const LabelOnLeft = () => <TextSwitch name={"labelLeft"} hasLabel labelPosition="left" />
LabelOnLeft.parameters = renderSourceAsHTML(LabelOnLeft());

export const AltBackground = () => <TextSwitch name={"alt"} alt hasLabel/>
AltBackground.parameters = {
  backgrounds: { default: 'dark' },
  ...renderSourceAsHTML(AltBackground())
};
