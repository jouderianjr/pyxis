import React, {FC} from 'react';
import {ComponentMeta} from '@storybook/react';
import {MINIMAL_VIEWPORTS} from '@storybook/addon-viewport';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import Tooltip, {Tooltips} from "./Tooltip";
import Button from "components/Button";
import {IconQuestionCircle} from "components/Icon/Icons";
import styles from './Tooltip.module.scss'

export default {
  title: 'Components/Tooltip 🚧/All Stories',
  parameters: {
    viewport: {
      viewports: MINIMAL_VIEWPORTS
    },
  }
} as ComponentMeta<typeof Tooltip>;

const mobileFirstViewport = {viewport: {defaultViewport: "mobile1"}}

const TooltipChildTemplate:FC<any> = (props) =>
  <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost" {...props}>Tooltip</Button>

const DefaultTemplate:FC = () => <Tooltip id="tooltip-id-default"><TooltipChildTemplate /></Tooltip>

export const Default = () => <div className={styles.wrapper}><DefaultTemplate /></div>
Default.parameters = renderSourceAsHTML(<DefaultTemplate />);

const DefaultOnMobileTemplate:FC = () => <Tooltip id="tooltip-id-default-mobile"><TooltipChildTemplate /></Tooltip>

export const DefaultOnMobile = () => <div className={styles.wrapper}><DefaultOnMobileTemplate /></div>
DefaultOnMobile.parameters = {
  ...mobileFirstViewport,
  ...renderSourceAsHTML(<DefaultOnMobileTemplate />)
};

export const Positions = () => <div className={`${styles.wrapper} ${styles.wrapperPadding2Xl}`}><Tooltips /></div>
Positions.parameters = renderSourceAsHTML(<Tooltips/>);

const BrandTemplate:FC = () => <Tooltip id="tooltip-id-brand" variant="brand"><TooltipChildTemplate /></Tooltip>

export const BrandVariant = () => <div className={styles.wrapper}><BrandTemplate /></div>
BrandVariant.parameters = renderSourceAsHTML(<BrandTemplate />);

const WithIconTemplate:FC = () => <Tooltip id="tooltip-id-withicon" hasIcon><TooltipChildTemplate /></Tooltip>

export const WithIcon = () => <div className={styles.wrapper}><WithIconTemplate /></div>
WithIcon.parameters = renderSourceAsHTML(<WithIconTemplate />);

const NoBottomsheetTitleTemplate:FC = () => <Tooltip id="tooltip-id-notitle" hasBottomSheetTitle={false}><TooltipChildTemplate /></Tooltip>

export const NoBottomsheetTitle = () => <div className={styles.wrapper}><NoBottomsheetTitleTemplate /></div>
NoBottomsheetTitle.parameters = {
  ...mobileFirstViewport,
  ...renderSourceAsHTML(<NoBottomsheetTitleTemplate/>)
};

const AltBackgroundTemplate:FC = () =>
  <Tooltip id="tooltip-id-alt" alt><TooltipChildTemplate alt /></Tooltip>

export const AltBackground = () => <div className={styles.wrapper}><AltBackgroundTemplate /></div>

AltBackground.parameters = {
  backgrounds: { default: 'dark' },
  ...renderSourceAsHTML(<AltBackgroundTemplate />)
};
