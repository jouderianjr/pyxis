import React from 'react';
import {ComponentMeta} from '@storybook/react';
import renderSourceAsHTML from "stories/utils/renderSourceAsHTML";
import Form from "./Form";
import Legend from "./Legend/Legend";

export default {
  title: 'Components - Form/All Stories',
} as ComponentMeta<typeof Form>;

export const FormAnatomy = () => (
  <div className="form-show-grid">
    {FormAnatomyInner()}
  </div>
);
const FormAnatomyInner = () => (
  <form className="form">
    <fieldset className="form-fieldset">
      <div className="form-grid">
        <div className="form-grid__row">
          <div className="form-grid__row__column">
            <div className="form-item" />
          </div>
          <div className="form-grid__row__column">
            <div className="form-item" />
          </div>
        </div>
      </div>
    </fieldset>
  </form>
)
FormAnatomy.parameters = renderSourceAsHTML(FormAnatomyInner());

export const GridDefaultGap = () => (
  <div className="form-show-grid">
    {GridDefaultGapInner()}
  </div>
);
const GridDefaultGapInner = () => (
  <div className="form-grid">
    <div className="form-grid__row" />
    <div className="form-grid__row" />
  </div>
)
GridDefaultGap.parameters = renderSourceAsHTML(GridDefaultGapInner());

export const GridWithLargeGap = () => (
  <div className="form-show-grid">
    {GridWithLargeGapInner()}
  </div>
);
const GridWithLargeGapInner = () => (
  <div className="form-grid form-grid--gap-large">
    <div className="form-grid__row" />
    <div className="form-grid__row" />
  </div>
)
GridWithLargeGap.parameters = renderSourceAsHTML(GridWithLargeGapInner());

export const SubGrid = () => (
  <div className="form-show-grid">
    {SubGridInner()}
  </div>
);
const SubGridInner = () => (
  <div className="form-grid">
    <div className="form-grid__row form-grid__row--spacing-large" />
    <div className="form-grid">
      <div className="form-grid__row" />
      <div className="form-grid__row" />
    </div>
    <div className="form-grid__row" />
  </div>
)
SubGrid.parameters = renderSourceAsHTML(SubGridInner());

export const RowDefault = () => (
  <div className="form-show-grid">
    {RowDefaultInner()}
  </div>
);
const RowDefaultInner = () => (
  <div className="form-grid">
    <div className="form-grid__row" />
  </div>
)
RowDefault.parameters = renderSourceAsHTML(RowDefaultInner());

export const RowMedium = () => (
  <div className="form-show-grid">
    {RowMediumInner()}
  </div>
);
const RowMediumInner = () => (
  <div className="form-grid">
    <div className="form-grid__row form-grid__row--medium" />
  </div>
)
RowMedium.parameters = renderSourceAsHTML(RowMediumInner());

export const RowSmall = () => (
  <div className="form-show-grid">
    {RowSmallInner()}
  </div>
);
const RowSmallInner = () => (
  <div className="form-grid">
    <div className="form-grid__row form-grid__row--small" />
  </div>
)
RowSmall.parameters = renderSourceAsHTML(RowSmallInner());

export const Columns = () => (
  <div className="form-show-grid">
    {ColumnsInner()}
  </div>
);
const ColumnsInner = () => (
  <div className="form-grid">
    <div className="form-grid__row">
      <div className="form-grid__row__column">1fr</div>
      <div className="form-grid__row__column">1fr</div>
    </div>
    <div className="form-grid__row">
      <div className="form-grid__row__column">1fr</div>
      <div className="form-grid__row__column form-grid__row__column--span-2">span-2</div>
    </div>
    <div className="form-grid__row">
      <div className="form-grid__row__column">1fr</div>
      <div className="form-grid__row__column form-grid__row__column--span-3">span-3</div>
    </div>
    <div className="form-grid__row">
      <div className="form-grid__row__column">1fr</div>
      <div className="form-grid__row__column form-grid__row__column--span-4">span-4</div>
    </div>
    <div className="form-grid__row">
      <div className="form-grid__row__column">1fr</div>
      <div className="form-grid__row__column form-grid__row__column--span-5">span-5</div>
    </div>
  </div>
)
Columns.parameters = renderSourceAsHTML(ColumnsInner());

export const RealWorldExample = () => (
  <Form />
);
