import React, { FC } from 'react';
import { IconProps } from 'components/Icon';

export const getAddonStringType = (addon:Type):StringType => {
  if (addon && typeof addon === 'string') return 'text';
  return 'icon';
};

const Addon: FC<AddonProps> = ({ addon, id }) => (
  <div
    className="form-field__addon"
    data-testid={id}
    id={id}
  >
    {typeof addon === 'string' ? addon : addon({})}
  </div>
);

export default Addon;

export type Type = FC<IconProps> | string;
export type StringType = 'icon' | 'text';

interface AddonProps {
  addon: Type;
  id: string;
}
