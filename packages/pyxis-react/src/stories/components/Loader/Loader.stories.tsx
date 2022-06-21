import React from 'react';
import {ComponentMeta} from '@storybook/react';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import Loader from "./Loader";

export default {
  title: 'Components - Display/Loader 🚧/All Stories',
} as ComponentMeta<typeof Loader>;

export const SpinnerLoader = () => <Loader type="spinner" />
SpinnerLoader.parameters = renderSourceAsHTML(SpinnerLoader());

export const CarLoader = () => <Loader type="car" />
CarLoader.parameters = renderSourceAsHTML(CarLoader());

export const SpinnerWithDescription = () => <Loader type="spinner" hasText />
SpinnerWithDescription.parameters = renderSourceAsHTML(SpinnerWithDescription());

export const CarWithDescription = () => <Loader type="car" hasText />
CarWithDescription.parameters = renderSourceAsHTML(CarWithDescription());

export const SpinnerLoaderSmall = () => <Loader type="spinner" size={"small"}/>
SpinnerLoaderSmall.parameters = renderSourceAsHTML(SpinnerLoaderSmall());

export const SpinnerAltBackground = () => <Loader type="spinner" hasText alt />
SpinnerAltBackground.parameters = {
  backgrounds: { default: 'dark' },
  ...renderSourceAsHTML(SpinnerAltBackground())
};

export const CarAltBackground = () => <Loader type="car" hasText alt />
CarAltBackground.parameters = {
  backgrounds: { default: 'dark' },
  ...renderSourceAsHTML(CarAltBackground())
};
