import React, { FC, LabelHTMLAttributes } from 'react';
import classNames from 'classnames';

const getClasses = (size: Size, className?: string) => classNames(
  'form-label',
  className,
  { 'form-label--small': size === 'small' },
);

const Label: FC<LabelProps> = ({
  children,
  className,
  id,
  size = 'medium',
  subText,
  ...restProps
}) => (
  <label
    className={getClasses(size, className)}
    data-testid={id}
    id={id}
    {...restProps}
  >
    {children}
    {subText && (
    <small className="form-label__sub">
      {subText}
    </small>
    )}
  </label>
);

export default Label;

type Size
  = 'medium'
  | 'small'

export interface LabelProps extends LabelHTMLAttributes<HTMLLabelElement> {
  children: string;
  size?: Size;
  subText?: string;
}
