import React, {FC} from 'react';
import Table, {TableRow} from 'stories/utils/Table';
import Badge from "components/Badge";
import {Variant} from "components/Badge/Badge";

export default {
  title: 'Test/Badge',
  component: Badge,
};

const variants: Variant[] = ['brand', 'action', 'error', 'success', 'alert', 'neutralGradient', 'brandGradient', 'ghost'];

const generateBody: TableRow[] = [
  [
    "Neutral",
    <Badge>Badge</Badge>,
    <div className="alt-wrapper">
      <Badge alt>Badge</Badge>
    </div>,
  ],
  ...variants.map(
    (variant) => [
      variant,
      <Badge variant={variant}>Badge</Badge>,
      <div className="alt-wrapper">
        <Badge alt variant={variant}>Badge</Badge>
      </div>,
    ]
  )
];

export const Test: FC = () => (
  <Table
    head={['Variant', 'Sample', 'Alt']}
    body={generateBody}
  />
);
