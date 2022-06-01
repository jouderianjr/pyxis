import React from 'react';
import {ComponentMeta} from '@storybook/react';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import Modal from "./Modal";
import styles from "../Tooltip/Tooltip.module.scss";

export default {
  title: 'Components/Modal 🚧/All Stories',
} as ComponentMeta<typeof Modal>;

const mobileFirstViewport = { viewport: { defaultViewport: "xxsmall" } }

export const Default = () => <Modal />
Default.parameters = renderSourceAsHTML(Default());

export const DefaultOnMobile = () => <Modal />
DefaultOnMobile.parameters = {
  ...mobileFirstViewport,
  ...renderSourceAsHTML(DefaultOnMobile())
};

export const WithSmallSize = () => <Modal size="small" shortContent />
WithSmallSize.parameters = renderSourceAsHTML(WithSmallSize());

export const WithCentered = () => <Modal size="small" isCentered shortContent />
WithCentered.parameters = renderSourceAsHTML(WithCentered());

export const HeaderWithBadge = () => <Modal size="small" withBadge shortContent />
HeaderWithBadge.parameters = renderSourceAsHTML(HeaderWithBadge());

export const HeaderWithIcon = () => <Modal size="small" withIcon shortContent />
HeaderWithIcon.parameters = renderSourceAsHTML(HeaderWithIcon());

export const HeaderSticky = () => <Modal size="small" stickyHeader />
HeaderSticky.parameters = renderSourceAsHTML(HeaderSticky());

export const HeaderCustom = () => <Modal size="small" customHeader={<div>💈 Custom header</div>} shortContent />
HeaderCustom.parameters = renderSourceAsHTML(HeaderCustom());

export const FooterText = () => <Modal size="medium" footerText="Footer text" />
FooterText.parameters = renderSourceAsHTML(FooterText());

export const FooterAlt = () => <Modal size="medium" altFooter />
FooterAlt.parameters = renderSourceAsHTML(FooterAlt());

export const FooterSticky = () => <Modal size="small" stickyFooter />
FooterSticky.parameters = renderSourceAsHTML(FooterSticky());

export const FooterWithFullWidthButton = () => <Modal size="small" fullWidthButton />
FooterWithFullWidthButton.parameters = renderSourceAsHTML(FooterWithFullWidthButton());

export const FooterCustom = () => <Modal size="small" customFooter={<div>💈 Custom footer</div>} />
FooterCustom.parameters = renderSourceAsHTML(FooterCustom());